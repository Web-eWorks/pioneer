// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#pragma once

#include "OpenGLLibs.h"

#include <string>
#include <vector>

namespace Graphics {

	namespace OGL {

		struct ShaderCompileException {};
		struct ProgramException {};

		struct ProgramDef;
		class Shader;

		/*
		* A Program is a specific, immutable variant of a shader that maps closely to
		* the underlying API's terminology (Program, GraphicsPipeline, etc.)
		*/
		class Program {
		public:
			Program(Shader *shader, const ProgramDef &def);
			~Program();

			void Reload(Shader *shader, const ProgramDef &def);
			bool Loaded() const { return success; }

			GLuint GetConstantLocation(uint32_t binding) const { return m_constants[binding]; }
			GLuint GetProgramID() const { return m_program; }

		protected:
			GLuint LoadShaders(const ProgramDef &def);
			void InitUniforms(Shader *shader);

			GLuint m_program;
			bool success;

			// map of push constant bindings to glUniform locations
			std::vector<GLuint> m_constants;
		};

	} // namespace OGL

} // namespace Graphics
