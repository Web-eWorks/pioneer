// Copyright © 2008-2023 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#ifndef _SHIPTYPE_H
#define _SHIPTYPE_H

#include "ship/Propulsion.h"
#include <map>
#include <string>
#include <vector>

struct ShipType {
	enum class HardpointTag { // <enum scope='ShipType::HardpointTag' name=HardpointTag public>
		Gun,
		Ordnance,
		Utility,
	};

	// Information about a specific gun mount on a ship hull
	struct HardpointInfo {
		HardpointTag type;
		std::string tagname;
		vector2f traverse;
		uint32_t size;
		uint32_t index;
	};

	enum Tag { // <enum scope='ShipType' name=ShipTypeTag prefix=TAG_ public>
		TAG_NONE,
		TAG_SHIP,
		TAG_STATIC_SHIP,
		TAG_MISSILE,
		TAG_MAX // <enum skip>
	};

	typedef std::string Id;

	ShipType(){};
	ShipType(const Id &id, const std::string &path);

	////////
	Tag tag;
	Id id;
	std::string name;
	std::string shipClass;
	std::string manufacturer;
	std::string modelName;
	std::string cockpitName;
	float linThrust[THRUSTER_MAX];
	float angThrust;
	float linAccelerationCap[THRUSTER_MAX];
	std::map<std::string, int> slots;
	std::map<std::string, bool> roles;
	std::vector<HardpointInfo> hardpoints;
	Color globalThrusterColor; // Override default color for thrusters
	bool isGlobalColorDefined; // If globalThrusterColor is filled with... a color :)
	Color directionThrusterColor[THRUSTER_MAX];
	bool isDirectionColorDefined[THRUSTER_MAX];
	double thrusterUpgrades[4];
	double atmosphericPressureLimit;
	int capacity; // tonnes
	int hullMass;
	float effectiveExhaustVelocity; // velocity at which the propellant escapes the engines
	int fuelTankMass;				//full fuel tank mass, on top of hullMass

	//values for atmospheric flight
	double topCrossSection;
	double sideCrossSection;
	double frontCrossSection;
	double topDragCoeff;
	double sideDragCoeff;
	double frontDragCoeff;

	double shipLiftCoefficient;
	double atmoStability;

	// storing money as a double is weird, but the value is a double on the Lua side anyway,
	// so we don't lose anything by storing it as a double here too
	double baseprice;

	int hyperdriveClass;
	int minCrew, maxCrew; // XXX really only for Lua, but needs to be declared in the ship def

	std::string definitionPath;
	///////

	// percentage (ie, 0--100) of tank used per second at full thrust
	float GetFuelUseRate() const;

	static const std::string POLICE;
	static const std::string MISSILE_GUIDED;
	static const std::string MISSILE_NAVAL;
	static const std::string MISSILE_SMART;
	static const std::string MISSILE_UNGUIDED;

	static std::map<Id, const ShipType> types;
	static std::vector<Id> player_ships;
	static std::vector<Id> static_ships;
	static std::vector<Id> missile_ships;

	static void Init();
	static const ShipType *Get(const char *name)
	{
		std::map<Id, const ShipType>::iterator t = types.find(name);
		if (t == types.end())
			return 0;
		else
			return &(*t).second;
	}

private:
	void LoadFromJson(Json &data);
};

#endif /* _SHIPTYPE_H */
