

#include "GunManager.h"
#include "LuaColor.h"
#include "LuaMetaType.h"
#include "LuaObject.h"
#include "src/lua.h"
#include <type_traits>

void pi_lua_generic_push(lua_State *l, const GunManager::GunState *s)
{
	LuaTable tab(l);
	tab.Set("mount", s->mount);
	tab.Set("firing", s->firing);
	tab.Set("temperature", s->temperature);
	tab.Set("gunData", s->gunData);
}

void pi_lua_generic_push(lua_State *l, const ProjectileData &p)
{
	LuaTable tab(l);
	tab.Set("lifespan", p.lifespan);
	tab.Set("damage", p.damage);
	tab.Set("length", p.length);
	tab.Set("width", p.width);
	tab.Set("speed", p.speed);
	tab.Set("color", p.color);
	tab.Set("mining", p.mining);
	tab.Set("beam", p.beam);
}

void pi_lua_generic_pull(lua_State *l, int index, ProjectileData &p)
{
	LuaTable tab(l, index);
	p.lifespan = tab.Get<float>("lifespan");
	p.damage = tab.Get<float>("damage");
	p.length = tab.Get<float>("length");
	p.width = tab.Get<float>("width");
	p.speed = tab.Get<float>("speed");
	p.color = tab.Get<Color>("color");
	p.mining = tab.Get<bool>("mining");
	p.beam = tab.Get<bool>("beam");
}

template <>
const char *LuaObject<GunData>::s_type = "GunData";

template <>
void LuaObject<GunData>::RegisterClass()
{
	static LuaMetaType<GunData> s_metaType(s_type);
	s_metaType.CreateMetaType(Lua::manager->GetLuaState());

	s_metaType.StartRecording()
		.AddCallCtor([](lua_State *l) {
			LuaPush(l, new GunData());
			return 1;
		})
		.AddMember("firingRPM", &GunData::firingRPM)
		.AddMember("firingHeat", &GunData::firingHeat)
		.AddMember("coolingPerSecond", &GunData::coolingPerSecond)
		.AddMember("overheatThreshold", &GunData::overheatThreshold)
		.AddMember("gunModel", &GunData::gunModel)
		.AddMember("projectile", &GunData::projectile)
		.AddMember("numBarrels", &GunData::numBarrels)
		.AddMember("staggerBarrels", &GunData::staggerBarrels)
		.StopRecording();

	CreateClass(&s_metaType);
}

template <>
const char *LuaObject<GunManager>::s_type = "GunManager";

template <>
void LuaObject<GunManager>::RegisterClass()
{
	static LuaMetaType<GunManager> s_metaType(s_type);
	s_metaType.CreateMetaType(Lua::manager->GetLuaState());

	s_metaType.StartRecording()
		.AddFunction("IsGunMounted", &GunManager::IsGunMounted)
		.AddFunction("GetNumMounts", &GunManager::GetNumMounts)
		.AddFunction("MountGun", &GunManager::MountGun)
		.AddFunction("UnmountGun", &GunManager::UnmountGun)
		.AddFunction("GetGunState", &GunManager::GetGunState)
		.AddFunction("IsFiring", [](lua_State *l, GunManager *s) {
			if (lua_gettop(l) > 1)
				LuaPush(l, s->IsFiring(lua_tonumber(l, 2)));
			else
				LuaPush(l, s->IsFiring());

			return 1;
		})
		.StopRecording();

	CreateClass(&s_metaType);
}
