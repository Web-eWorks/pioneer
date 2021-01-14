// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#pragma once

#include "Projectile.h"
#include "RefCounted.h"
#include "ShipType.h"
#include "scenegraph/Model.h"
#include <string>

// Static information about a specific model of gun (e.g. 1MW pulse laser)
struct GunData : public RefCounted {
	float firingRPM = 240; // number of shots per minute (60s / time between shots)
	float firingHeat = 4.5; // amount of thermal energy(kJ) emitted into the system when firing

	//TODO: integrate this with a whole-ship cooling system
	float coolingPerSecond = 14.2; // amount of thermal energy(kJ) removed per second
	float overheatThreshold = 280; // total amount of thermal energy(kJ) the gun can store while functioning

	RefCountedPtr<SceneGraph::Model> gunModel;
	ProjectileData projectile;
	uint8_t numBarrels = 1; // total number of barrels on the model
};

class GunManager : public DeleteEmitter {
public:

	struct GunState {
		uint32_t mount = 0; // index of the gun mount in the model
		bool firing = false; // is the gun currently firing

		uint8_t lastBarrel = 0; // the last barrel used to fire (for multi-barrel weapons)
		float lastFireTime = 0; // time the gun was last fired, interval [0..3600s)
		float temperature = 0; // current gun temperature
		// TODO: integrate this with a whole-ship cooling system
		float coolerOverclock = 1.0; // any boost to gun coolers from ship equipment
		float powerOverclock = 1.0; // boost to overall firerate (and corresponding increase in heat generation)

		vector3f targetLeadPos;
		vector3f currentLeadDir;

		RefCountedPtr<GunData> gunData; // static information about the model of gun
	};

	GunManager();

	void Init(DynamicBody *b, ShipType *shipType, SceneGraph::Model *m);

	void SaveToJson(Json &jsonObj, Space *space);
	void LoadFromJson(const Json &jsonObj, Space *space);

	bool MountGun(uint32_t num, RefCountedPtr<GunData> gunData);
	void UnmountGun(uint32_t num);

	void Fire(uint32_t num);
	void SetTrackingTarget(Body *target);

	uint32_t GetNumMounts() const;
	bool IsGunMounted(uint32_t num) const;

	bool IsFiring() const { return m_isAnyFiring; }
	bool IsFiring(uint32_t num) const { return IsGunMounted(num) ? GetGunState(num)->firing : false; }

	const GunState *GetGunState(uint32_t num) const;
	const Body *GetTargetBody() const { return m_targetBody; }

private:
	struct GunMount {
		vector3d pos;
		vector3d dir;
		ShipType::HardpointInfo *hardpoint;
	};

	// Calculate the position a given gun should aim at to hit the current target body
	// This is effectively the position of the target at T+n, factoring in an approximation
	// of the observed acceleration of the target
	void CalcGunLead(GunState *state, vector3d relativeVelocity, vector3d relativeAcceleration);

	std::vector<GunState> m_mountedGuns;
	// XXX this should be part of ShipType, but need to further investigate dependency on
	// SceneGraph in that system's init (loading model structure separately from loading mesh data)
	std::vector<GunMount> m_gunMounts;
	DynamicBody *m_parent;
	Body *m_targetBody;
	bool m_isAnyFiring;
	bool m_shouldTrackTarget;
};
