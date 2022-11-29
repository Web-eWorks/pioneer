// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#pragma once

#include "Projectile.h"
#include "RefCounted.h"
#include "ShipType.h"
#include "lua/LuaWrappable.h"
#include "scenegraph/Model.h"
#include <string>

// Static information about a specific model of gun (e.g. 1MW pulse laser)
struct GunData : public RefCounted {
	float firingRPM = 240;	// number of shots per minute (60s / time between shots)
	float firingHeat = 4.5; // amount of thermal energy(kJ) emitted into the system when firing

	//TODO: integrate this with a whole-ship cooling system
	float coolingPerSecond = 14.2; // amount of thermal energy(kJ) removed per second
	float overheatThreshold = 280; // total amount of thermal energy(kJ) the gun can store while functioning

	SceneGraph::Model *gunModel;
	ProjectileData projectile;
	uint8_t numBarrels = 1;		 // total number of barrels on the model
	bool staggerBarrels = false; // should we fire one barrel after another, or both at the same time?
};

class GunManager : public LuaWrappable {
public:
	struct GunState {
		uint32_t mount = 0;			  // index of the gun mount in the model
		bool firing = false;		  // is the gun currently firing
		bool firedThisUpdate = false; // did the gun fire this update

		uint8_t lastBarrel = 0;	 // the last barrel used to fire (for multi-barrel weapons)
		double nextFireTime = 0; // time at which the gun will be ready to fire again
		float temperature = 0;	 // current gun temperature
		// TODO: integrate this with a whole-ship cooling system
		// Currently uses GunManager::m_coolingBoost
		// float coolerOverclock = 1.0; // any boost to gun coolers from ship equipment
		// float powerOverclock = 1.0; // boost to overall firerate (and corresponding increase in heat generation)

		vector3f currentLeadDir;
		vector3d currentLeadPos;

		RefCountedPtr<GunData> gunData; // static information about the model of gun
	};

	GunManager() = default;

	void Init(DynamicBody *b, const ShipType *shipType, SceneGraph::Model *m);

	void SaveToJson(Json &jsonObj, Space *space);
	void LoadFromJson(const Json &jsonObj, Space *space);

	bool MountGun(uint32_t num, RefCountedPtr<GunData> gunData);
	void UnmountGun(uint32_t num);

	void TimeStepUpdate(float deltaTime);

	void SetGunFiring(uint32_t num, bool firing);
	void StopFiringAllGuns();
	void SetTrackingTarget(Body *target);

	bool IsGunMounted(uint32_t num) const;
	uint32_t GetNumMounts() const { return m_gunMounts.size(); }

	uint32_t GetFirstFreeMount() const;
	uint32_t GetNumFreeMounts() const;

	bool IsFiring() const { return m_isAnyFiring; }
	bool IsFiring(uint32_t num) const { return IsGunMounted(num) ? m_mountedGuns[num].firing : false; }

	const ShipType::HardpointInfo *GetHardpointForMount(uint32_t mount) const;
	const GunState *GetGunState(uint32_t num) const { return IsGunMounted(num) ? &m_mountedGuns[num] : nullptr; }
	const Body *GetTargetBody() const { return m_targetBody; }

	// TODO: separate this functionality to a ship-wide cooling system
	void SetCoolingBoost(float boost) { m_coolingBoost = boost; }

private:
	struct GunMount {
		vector3d pos;
		vector3d dir;
		vector2f traverseTan; // tangent of the traverse
		const ShipType::HardpointInfo *hardpoint;
	};

	// Handle checking and firing a given gun.
	void Fire(uint32_t num);

	// Calculate the position a given gun should aim at to hit the current target body
	// This is effectively the position of the target at T+n
	void CalcGunLead(GunState *state, vector3d position, vector3d relativeVelocity);

	std::vector<GunState> m_mountedGuns;
	// XXX this should be part of ShipType, but need to further investigate dependency on
	// SceneGraph in that system's init (loading model structure separately from loading mesh data)
	std::vector<GunMount> m_gunMounts;

	sigc::connection m_targetDestroyedCallback;
	DynamicBody *m_parent = nullptr;
	Body *m_targetBody = nullptr;
	bool m_isAnyFiring = false;
	bool m_shouldTrackTarget = false;
	float m_coolingBoost = 1.0;
};
