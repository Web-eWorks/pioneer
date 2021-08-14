// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#include "GunManager.h"
#include "scenegraph/MatrixTransform.h"

void GunManager::Init(DynamicBody *b, ShipType *t, SceneGraph::Model *m)
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

bool GunManager::MountGun(uint32_t num, RefCountedPtr<GunData> gunData)
{
	if (num >= m_gunMounts.size() || num >= m_mountedGuns.size())
		return false;


}
