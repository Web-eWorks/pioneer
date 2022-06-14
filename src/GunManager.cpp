// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#include "GunManager.h"

#include "Beam.h"
#include "Game.h"
#include "Pi.h"
#include "scenegraph/MatrixTransform.h"

void GunManager::Init(DynamicBody *b, const ShipType *t, SceneGraph::Model *m)
{
	m_parent = b;
	m_gunMounts.reserve(t->hardpoints.size());
	m_mountedGuns.reserve(t->hardpoints.size());

	for (auto &hardpoint : t->hardpoints) {
		SceneGraph::MatrixTransform *tag = m->FindTagByName(hardpoint.tagname);
		if (tag == nullptr)
			continue;

		GunMount newMount;
		newMount.pos = vector3d(tag->GetTransform().GetTranslate());
		newMount.dir = vector3d(tag->GetTransform().GetOrient().VectorZ());
		newMount.hardpoint = &hardpoint;
	}
}

void GunManager::SaveToJson(Json &jsonObj, Space *space)
{
}

void GunManager::LoadFromJson(const Json &jsonObj, Space *space)
{
}

bool GunManager::MountGun(uint32_t num, RefCountedPtr<GunData> gunData)
{
	if (num >= m_gunMounts.size() || num >= m_mountedGuns.size())
		return false;

	if (m_mountedGuns[num].gunData.Valid())
		return false; // the gun is already mounted!

	// TODO: anything more we need to do here?
	m_mountedGuns[num] = GunState();
	m_mountedGuns[num].mount = num;
	m_mountedGuns[num].gunData = std::move(gunData);

	return true;
}

void GunManager::UnmountGun(uint32_t num)
{
	if (num >= m_mountedGuns.size() || !m_mountedGuns[num].gunData.Valid())
		return;

	// TODO: anything more we need to do here?
	m_mountedGuns[num] = GunState();
}

void GunManager::SetGunFiring(uint32_t num, bool firing)
{
	if (!IsGunMounted(num))
		return;

	GunState &state = m_mountedGuns[num];

	if (!state.firing)
		state.nextFireTime = Pi::game->GetTime();

	state.firing = firing;
	m_isAnyFiring = firing ? true : m_isAnyFiring;
}

void GunManager::StopFiringAllGuns()
{
	for (uint32_t i = 0; i < m_mountedGuns.size(); i++) {
		m_mountedGuns[i].firing = false;
	}

	m_isAnyFiring = false;
}

void GunManager::Fire(uint32_t num)
{
	GunState *gunState = &m_mountedGuns[num];
	GunData *gunData = gunState->gunData.Get();

	// either fire the next barrel in sequence or fire all at the same time
	size_t barrelStart = 0;
	size_t numBarrels = 1;
	if (gunData->staggerBarrels || gunData->numBarrels == 1) {
		barrelStart = (gunState->lastBarrel + 1) % gunData->numBarrels;
		gunState->lastBarrel = barrelStart;
	} else {
		numBarrels = gunData->numBarrels;
	}

	const matrix3x3d leadRot = Quaterniond(gunState->currentLeadDir).ToMatrix3x3<double>();
	const matrix3x3d &orient = m_parent->GetOrient();

	for (size_t idx = barrelStart; idx < barrelStart + numBarrels; idx++) {
		gunState->temperature += gunData->firingHeat;

		// TODO: get individual barrel locations from gun model and cache them
		const vector3d dir = (orient * leadRot * m_gunMounts[num].dir).Normalized();
		const vector3d pos = orient * vector3d(m_gunMounts[num].pos) + m_parent->GetPosition();

		if (gunData->projectile.beam) {
			Beam::Add(m_parent, gunData->projectile, pos, m_parent->GetVelocity(), dir);
		} else {
			Projectile::Add(m_parent, gunData->projectile, pos, m_parent->GetVelocity(), gunData->projectile.speed * dir);
		}
	}

	gunState->firedThisUpdate = true;
}

void GunManager::TimeStepUpdate(float deltaTime)
{
	bool isAnyFiring = false;

	for (GunState &gun : m_mountedGuns) {
		if (!gun.gunData.Valid())
			continue; // un-mounted gun slot

		gun.temperature = std::max(0.0f, gun.temperature - gun.gunData->coolingPerSecond * m_coolingBoost * deltaTime);
		double currentTime = Pi::game->GetTime();

		// determine if we should fire this update
		isAnyFiring |= gun.firing;
		if (gun.firing && currentTime >= gun.nextFireTime && gun.temperature < gun.gunData->overheatThreshold) {
			// time between shots, used to determine how many shots we need to 'catch up' on this timestep
			double deltaShot = 60.0 / gun.gunData->firingRPM;
			// only fire multiple shots per timestep if the accumulated error and the length of the timestep require it
			// e.g. 10x timescale could potentially have 2-3 shots per timestep with a high RPM weapon
			double accumTime = currentTime - gun.nextFireTime + deltaTime;
			uint32_t numShots = floor(accumTime / deltaShot);

			for (uint32_t i = 0; i < numShots; ++i)
				Fire(gun.mount);

			// set the next fire time, making sure to preserve accumulated (fractional) shot time
			gun.nextFireTime += deltaShot * numShots;

			// should never happen, but if our time rate gets completely out of whack we reset it
			if (gun.nextFireTime < currentTime)
				gun.nextFireTime = currentTime;
		} else {
			gun.firedThisUpdate = false;
		}

		if (m_shouldTrackTarget && m_targetBody) {
			vector3d relPosition = m_targetBody->GetPositionRelTo(m_parent);
			vector3d relVelocity = m_targetBody->GetVelocityRelTo(m_parent->GetFrame()) - m_parent->GetVelocity();
			vector3d relAcceleration = m_parent->GetLastForce() / m_parent->GetMass();

			if (m_targetBody->IsType(ObjectType::DYNAMICBODY)) {
				vector3d targetAccel = m_targetBody->GetOrientRelTo(m_parent->GetFrame()) * static_cast<DynamicBody *>(m_targetBody)->GetLastForce() / m_targetBody->GetMass();
				relAcceleration = targetAccel - relAcceleration;
			}

			const matrix3x3d &orient = m_parent->GetOrient();
			// bring velocity and acceleration into ship-space
			CalcGunLead(&gun, relPosition * orient, relVelocity * orient, relAcceleration * orient);
		} else {
			gun.currentLeadDir = vector3f(m_gunMounts[gun.mount].dir);
		}
	}

	m_isAnyFiring = isAnyFiring;
}

void GunManager::SetTrackingTarget(Body *target)
{
	m_shouldTrackTarget = (target != nullptr);
	m_targetBody = target;
}

bool GunManager::IsGunMounted(uint32_t num) const
{
	return num < m_mountedGuns.size() && m_mountedGuns[num].gunData.Valid();
}

static constexpr double MAX_LEAD_ANGLE = DEG2RAD(1.5);
void GunManager::CalcGunLead(GunState *state, vector3d position, vector3d relativeVelocity, vector3d relativeAcceleration)
{
	const vector3f forwardVector = vector3f(m_gunMounts[state->mount].dir);

	// calculate firing solution and relative velocity along our z axis
	// don't calculate lead if there's no gun there
	const double projspeed = state->gunData->projectile.speed;
	// generate a basic approximation ignoring acceleration to estimate travel time
	vector3d leadpos = position + relativeVelocity * (position.Length() / projspeed);
	// second-order approximation taking acceleration and velocity into account
	float travelTime = leadpos.Length() / projspeed;
	leadpos = position + (relativeVelocity + relativeAcceleration * travelTime) * travelTime;
	// third-order approximation (re-deriving travel time)
	travelTime = leadpos.Length() / projspeed;
	leadpos = position + (relativeVelocity + relativeAcceleration * travelTime) * travelTime;

	// float has plenty of precision when working with normalized directions.
	const vector3f targetDir = vector3f(leadpos.Normalized());
	const vector3f gunLeadTarget = (targetDir.Dot(forwardVector) >= cos(MAX_LEAD_ANGLE)) ? targetDir : forwardVector;
	// FIXME: for some unearthly reason, pointing directly at the lead target causes projectiles to overshoot by 2x
	// So we just interpolate by exactly half and it works perfectly. This is a pretty benign hack, all considered.
	Quaternionf interpTarget = Quaternionf::Slerp(Quaternionf(gunLeadTarget), Quaternionf(forwardVector), 0.5);

	float angle;
	interpTarget.GetAxisAngle(angle, state->currentLeadDir);
}
