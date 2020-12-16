// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#include "MultiMaterial.h"

#include "HeatGradientPar.h"
#include "RendererGL.h"
#include "StringF.h"
#include "TextureGL.h"
#include "graphics/Graphics.h"
#include "graphics/Material.h"
#include <sstream>

namespace Graphics {
	namespace OGL {

		MultiProgram::MultiProgram(const MaterialDescriptor &desc, int numLights)
		{
			numLights = Clamp(numLights, 1, 4);

			//build some defines
			std::stringstream ss;
			ss << "#define UNIFORM_BUFFERS\n";

			if (desc.textures > 0)
				ss << "#define TEXTURE0\n";
			if (desc.vertexColors)
				ss << "#define VERTEXCOLOR\n";
			if (desc.alphaTest)
				ss << "#define ALPHA_TEST\n";
			//using only one light
			if (desc.lighting && numLights > 0)
				ss << stringf("#define NUM_LIGHTS %0{d}\n", numLights);
			else
				ss << "#define NUM_LIGHTS 0\n";
			if (desc.normalMap && desc.lighting && numLights > 0)
				ss << "#define MAP_NORMAL\n";
			if (desc.specularMap)
				ss << "#define MAP_SPECULAR\n";
			if (desc.glowMap)
				ss << "#define MAP_EMISSIVE\n";
			if (desc.ambientMap)
				ss << "#define MAP_AMBIENT\n";
			if (desc.usePatterns)
				ss << "#define MAP_COLOR\n";
			if (desc.quality & HAS_HEAT_GRADIENT)
				ss << "#define HEAT_COLOURING\n";
			if (desc.instanced)
				ss << "#define USE_INSTANCING\n";

			m_name = "multi";
			m_defines = ss.str();

			LoadShaders(m_name, m_defines);
			InitUniforms();

			materialBlock.InitBlock("DrawData", m_program, 1);
		}

		LitMultiMaterial::LitMultiMaterial() :
			m_programs(),
			m_curNumLights(0)
		{
		}

		Program *MultiMaterial::CreateProgram(const MaterialDescriptor &desc)
		{
			return new MultiProgram(desc);
		}

		Program *LitMultiMaterial::CreateProgram(const MaterialDescriptor &desc)
		{
			m_curNumLights = m_renderer->m_numDirLights;
			return new MultiProgram(desc, m_curNumLights);
		}

		void LitMultiMaterial::SetProgram(Program *p)
		{
			m_programs[m_curNumLights] = p;
			m_program = p;
		}

		struct DrawDataBlock {
			// Material Struct
			Color4f diffuse;
			Color4f specular;
			Color4f emission;

			// Scene struct
			float lightIntensity[4];
			Color4f ambient;

			// matrix data
			matrix4x4f uViewMatrix;
			matrix4x4f uViewMatrixInverse;
			matrix4x4f uViewProjectionMatrix;

			vector3f heatingNormal;
			float heatingAmount;
		};
		static_assert(sizeof(DrawDataBlock) == 288, "");

		void MultiMaterial::Apply()
		{
			OGL::Material::Apply();

			MultiProgram *p = static_cast<MultiProgram *>(m_program);

			p->diffuse.Set(this->diffuse);

			p->texture0.Set(this->texture0, 0);
			p->texture1.Set(this->texture1, 1);
			p->texture2.Set(this->texture2, 2);
			p->texture3.Set(this->texture3, 3);
			p->texture4.Set(this->texture4, 4);
			p->texture5.Set(this->texture5, 5);
			p->texture6.Set(this->texture6, 6);

			p->heatGradient.Set(this->heatGradient, 7);

			auto buffer = m_renderer->GetDrawUniformBuffer(sizeof(DrawDataBlock));
			{
				auto dataBlock = buffer->Allocate<DrawDataBlock>(1);
				dataBlock->diffuse = this->diffuse.ToColor4f();
				dataBlock->specular = this->specular.ToColor4f();
				dataBlock->specular.a = this->shininess;
				dataBlock->emission = this->emissive.ToColor4f();
				dataBlock->ambient = m_renderer->GetAmbientColor().ToColor4f();
				for (uint32_t i = 0; i < m_renderer->GetNumLights(); i++) {
					dataBlock->lightIntensity[i] = m_renderer->GetLight(i).GetIntensity();
				}

				const matrix4x4f &mv = m_renderer->GetTransform();
				const matrix4x4f &proj = m_renderer->GetProjection();
				dataBlock->uViewMatrix = mv;
				dataBlock->uViewMatrixInverse = mv.Inverse();
				dataBlock->uViewProjectionMatrix = proj * mv;
				// We handle the normal matrix by transposing the orientation part of the inverse view matrix in the shader

				if (GetDescriptor().quality & MaterialQuality::HAS_HEAT_GRADIENT) {
					if (nullptr != specialParameter0) {
						HeatGradientParameters_t *pMGP = static_cast<HeatGradientParameters_t *>(specialParameter0);
						dataBlock->heatingNormal = pMGP->heatingNormal;
						dataBlock->heatingAmount = pMGP->heatingAmount;
					} else {
						dataBlock->heatingNormal = vector3f(0.f, -1.f, 0.f);
						dataBlock->heatingAmount = 0.f;
					}
				}
			}
		}

		void LitMultiMaterial::Apply()
		{
			//request a new light variation
			if (m_curNumLights != m_renderer->m_numDirLights) {
				m_curNumLights = m_renderer->m_numDirLights;
				if (m_programs[m_curNumLights] == 0) {
					m_descriptor.dirLights = m_curNumLights; //hax
					m_programs[m_curNumLights] = m_renderer->GetOrCreateProgram(this);
				}
				m_program = m_programs[m_curNumLights];
			}

			MultiMaterial::Apply();

			CHECKERRORS();
		}

		void MultiMaterial::Unapply()
		{
			// Might not be necessary to unbind textures, but let's not old graphics code (eg, old-UI)
			if (heatGradient) {
				static_cast<TextureGL *>(heatGradient)->Unbind();
				glActiveTexture(GL_TEXTURE6);
			}
			if (texture6) {
				static_cast<TextureGL *>(texture6)->Unbind();
				glActiveTexture(GL_TEXTURE5);
			}
			if (texture5) {
				static_cast<TextureGL *>(texture5)->Unbind();
				glActiveTexture(GL_TEXTURE4);
			}
			if (texture4) {
				static_cast<TextureGL *>(texture4)->Unbind();
				glActiveTexture(GL_TEXTURE3);
			}
			if (texture3) {
				static_cast<TextureGL *>(texture3)->Unbind();
				glActiveTexture(GL_TEXTURE2);
			}
			if (texture2) {
				static_cast<TextureGL *>(texture2)->Unbind();
				glActiveTexture(GL_TEXTURE1);
			}
			if (texture1) {
				static_cast<TextureGL *>(texture1)->Unbind();
				glActiveTexture(GL_TEXTURE0);
			}
			if (texture0) {
				static_cast<TextureGL *>(texture0)->Unbind();
			}
		}

	} // namespace OGL
} // namespace Graphics
