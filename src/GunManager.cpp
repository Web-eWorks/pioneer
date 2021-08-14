// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#include "GunManager.h"

#include "Beam.h"
#include "Game.h"
#include "Pi.h"
#include "imgui/imgui.h"
#include "scenegraph/MatrixTransform.h"

void GunManager::Init(DynamicBody *b, const ShipType *t, SceneGraph::Model *m)
{
	m_parent = b;
	m_gunMounts.reserve(t->hardpoints.size());
	m_mountedGuns.reserve(t->hardpoints.size());

	for (auto &hardpoint : t->hardpoints) {
		if (hardpoint.type != ShipType::HardpointTag::Gun)
			continue;

		SceneGraph::MatrixTransform *tag = m->FindTagByName(hardpoint.tagname);
		if (tag == nullptr) {
			Log::Warning("Missing hardpoint tag {} in model {}\n", hardpoint.tagname, m->GetName());
			continue;
		}

		GunMount newMount;
		newMount.pos = vector3d(tag->GetTransform().GetTranslate());
		newMount.dir = vector3d(tag->GetTransform().GetOrient().VectorZ());
		newMount.traverseTan = vector2f(
			tan(DEG2RAD(hardpoint.traverse.x)),
			tan(DEG2RAD(hardpoint.traverse.y)));
		newMount.hardpoint = &hardpoint;
		m_gunMounts.emplace_back(std::move(newMount));
		m_mountedGuns.push_back({});
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
	GunMount *gunMount = &m_gunMounts[num];
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

	const matrix3x3d leadRot = Quaterniond(vector3d(gunState->currentLeadDir), gunMount->dir).ToMatrix3x3<double>();
	const matrix3x3d &orient = m_parent->GetOrient();

	for (size_t idx = barrelStart; idx < barrelStart + numBarrels; idx++) {
		gunState->temperature += gunData->firingHeat;
		// TODO: get individual barrel locations from gun model and cache them
		const vector3d dir = (orient * leadRot * gunMount->dir).Normalized();
		const vector3d pos = orient * gunMount->pos + m_parent->GetPosition();

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

	static ImGuiOnceUponAFrame thisFrame;
	bool shouldDrawDebug = m_parent && m_parent->IsType(ObjectType::PLAYER) && thisFrame;
	if (shouldDrawDebug)
		ImGui::Begin("GunMangerDebug");

	if (shouldDrawDebug) {
		ImGui::Text("Gun mounts: %ld, mounted: %ld, target: %p", m_gunMounts.size(), m_mountedGuns.size(), m_targetBody);
		ImGui::Spacing();
	}

	for (GunState &gun : m_mountedGuns) {
		if (shouldDrawDebug) {
			ImGui::Text("== Gun Mount: %d, filled: %d", gun.mount, gun.gunData.Valid());
			if (gun.gunData.Valid()) {
				ImGui::Indent();
				ImGui::Text("Temperature: %f", gun.temperature);
				ImGui::Text("Firing: %d", gun.firing);
				ImGui::Text("Damage: %f", gun.gunData->projectile.damage);
				ImGui::Text("NextFireTime: %f", gun.nextFireTime);
				ImGui::Text("CurrentType: %f", Pi::game->GetTime());
				ImGui::Text("Firing RPM: %f", gun.gunData->firingRPM);
				ImGui::Text("Firing Heat: %f", gun.gunData->firingHeat);
				ImGui::Text("Beam: %d", gun.gunData->projectile.beam);
				ImGui::Text("Mining: %d", gun.gunData->projectile.mining);
				const auto &leadDir = gun.currentLeadDir;
				ImGui::Text("CurrentLeadDir: %f, %f, %f", leadDir.x, leadDir.y, leadDir.z);
				ImGui::Unindent();
			}
			ImGui::Spacing();
		}
		if (!gun.gunData.Valid())
			continue; // un-mounted gun slot

		if (m_shouldTrackTarget && m_targetBody && !gun.gunData->projectile.beam) {
			const matrix3x3d &orient = m_parent->GetOrient();
			const vector3d relPosition = m_targetBody->GetPositionRelTo(m_parent);
			const vector3d relVelocity = m_targetBody->GetVelocityRelTo(m_parent->GetFrame()) - m_parent->GetVelocity();

			// bring velocity and acceleration into ship-space
			CalcGunLead(&gun, relPosition * orient, relVelocity * orient);
		} else {
			gun.currentLeadDir = vector3f(m_gunMounts[gun.mount].dir);
		}

		gun.temperature = std::max(0.0f, gun.temperature - gun.gunData->coolingPerSecond * m_coolingBoost * deltaTime);
		double currentTime = Pi::game->GetTime();

		// determine if we should fire this update
		isAnyFiring |= gun.firing;
		if (gun.firing && currentTime >= gun.nextFireTime && gun.temperature < gun.gunData->overheatThreshold) {

			// time between shots, used to determine how many shots we need to 'catch up' on this timestep
			double deltaShot = 60.0 / gun.gunData->firingRPM;
			// only fire multiple shots per timestep if the accumulated error and the length of the timestep require it
			// given that timescale is set to 1 while in combat, this is likely not going to be required except for NPCs
			double accumTime = currentTime - gun.nextFireTime + deltaTime;
			uint32_t numShots = 1 + floor(accumTime / deltaShot);

			for (uint32_t i = 0; i < numShots; ++i)
				Fire(gun.mount);

			// set the next fire time, making sure to preserve accumulated (fractional) shot time
			gun.nextFireTime += deltaShot * numShots;

		} else {
			gun.firedThisUpdate = false;
		}

		// ensure next fire time is properly handled (e.g. during gun overheat)
		if (gun.firing)
			gun.nextFireTime = std::max(gun.nextFireTime, currentTime);
	}

	m_isAnyFiring = isAnyFiring;
	if (shouldDrawDebug)
		ImGui::End();
}

void GunManager::SetTrackingTarget(Body *target)
{
	if (m_targetBody)
		m_targetDestroyedCallback.disconnect();

	m_shouldTrackTarget = (target != nullptr);
	m_targetBody = target;

	if (target)
		m_targetDestroyedCallback = target->onDelete.connect([=]() {
			this->SetTrackingTarget(nullptr);
		});
}

bool GunManager::IsGunMounted(uint32_t num) const
{
	return num < m_mountedGuns.size() && m_mountedGuns[num].gunData.Valid();
}

void GunManager::CalcGunLead(GunState *state, vector3d position, vector3d relativeVelocity)
{
	const vector3f forwardVector = vector3f(m_gunMounts[state->mount].dir);

	// calculate firing solution and relative velocity along our z axis
	const double projspeed = state->gunData->projectile.speed;
	// generate a basic approximation to estimate travel time
	vector3d leadpos = position + relativeVelocity * (position.Length() / projspeed);
	// second-order approximation
	float travelTime = leadpos.Length() / projspeed;
	leadpos = position + (relativeVelocity)*travelTime;
	state->currentLeadPos = leadpos;

	// float has plenty of precision when working with normalized directions.
	const vector3f targetDir = vector3f(leadpos.Normalized());
	const Quaternionf forwardToZ(vector3f(0, 0, -1), forwardVector);

	// We represent the maximum traverse of the weapon as an ellipse relative
	// to the -Z axis of the gun.
	// To determine whether the lead target is within this traverse, we modify
	// the coordinate system such that the ellipse becomes the unit circle in
	// 2D space, and test the length of the 2D components of the direction
	// vector.
	vector2f traverseRel = vector3(forwardToZ * targetDir).xy() / m_gunMounts[state->mount].traverseTan;
	state->currentLeadDir = (targetDir.Dot(forwardVector) > 0 && traverseRel.LengthSqr() <= 1.0) ? targetDir : forwardVector;
}
