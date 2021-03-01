// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#ifndef _GRAPHICS_RENDERSTATE_H
#define _GRAPHICS_RENDERSTATE_H
#include "graphics/Types.h"

namespace Graphics {

	struct RenderStateDesc {
		RenderStateDesc() :
			blendMode(BLEND_SOLID),
			cullMode(CULL_BACK),
			primitiveType(PrimitiveType::TRIANGLES),
			depthTest(true),
			depthWrite(true)
		{
		}

		bool operator!=(const RenderStateDesc &rhs) const { return !(*this == rhs); }
		bool operator==(const RenderStateDesc &rhs) const
		{
			return blendMode == rhs.blendMode && cullMode == rhs.cullMode && primitiveType == rhs.primitiveType && depthTest == rhs.depthTest && depthWrite == rhs.depthWrite;
		}

		BlendMode blendMode;
		FaceCullMode cullMode;
		PrimitiveType primitiveType;
		bool depthTest;
		bool depthWrite;
	};

} // namespace Graphics

#endif
