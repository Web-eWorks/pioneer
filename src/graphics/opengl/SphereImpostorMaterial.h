// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt
#ifndef _GL2_SPHEREIMPOSTORMATERIAL_H
#define _GL2_SPHEREIMPOSTORMATERIAL_H
/*
 * Billboard sphere impostor
 */
#include "MaterialGL.h"
#include "Program.h"
#include "RendererGL.h"
#include "libs.h"

namespace Graphics {

	namespace OGL {

		class SphereImpostorMaterial : public Material {
		public:
			Program *CreateProgram(const MaterialDescriptor &) override
			{
				return new Program("billboard_sphereimpostor", "");
			}
		};
	} // namespace OGL
} // namespace Graphics
#endif
