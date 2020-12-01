// Copyright © 2008-2021 Pioneer Developers. See AUTHORS.txt for details
// Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

#include "attributes.glsl"
#include "lib.glsl"

#ifdef TEXTURE0
uniform sampler2D texture0; //diffuse
uniform sampler2D texture1; //specular
uniform sampler2D texture2; //glow
uniform sampler2D texture3; //ambient
uniform sampler2D texture4; //pattern
uniform sampler2D texture5; //color
uniform sampler2D texture6; //normal
in vec2 texCoord0;
#endif

#ifdef VERTEXCOLOR
in vec4 vertexColor;
#endif
#if (NUM_LIGHTS > 0)
in vec3 eyePos;
in vec3 normal;
#ifdef MAP_NORMAL
	in vec3 tangent;
	in vec3 bitangent;
#endif
#ifdef HEAT_COLOURING
	uniform sampler2D heatGradient;
	uniform vec3 heatingNormal; // normalised in viewspace
	uniform float heatingAmount; // 0.0 to 1.0 used for `u` component of heatGradient texture
#endif // HEAT_COLOURING
#endif // (NUM_LIGHTS > 0)

#ifndef UNIFORM_BUFFERS
uniform Scene scene;
uniform Material material;
#endif

out vec4 frag_color;

void getSurface(inout Surface surf)
{
#ifdef VERTEXCOLOR
	surf.color = vertexColor;
#else
	surf.color = material.diffuse;
#endif
#ifdef TEXTURE0
	surf.color *= texture(texture0, texCoord0);
#endif

	//patterns - simple lookup
#ifdef MAP_COLOR
	vec4 pat = texture(texture4, texCoord0);
	vec4 mapColor = texture(texture5, vec2(pat.r, 0.0));
	vec4 tint = mix(vec4(1.0),mapColor,pat.a);
	surf.color *= tint;
#endif

	surf.specular = material.specular.xyz;
#ifdef MAP_SPECULAR
	surf.specular *= texture(texture1, texCoord0).xyz;
#endif
	surf.shininess = material.shininess;

#if (NUM_LIGHTS > 0)
//directional lighting
#ifdef MAP_NORMAL
	vec3 bump = (texture(texture6, texCoord0).xyz * 2.0) - vec3(1.0);
	mat3 tangentFrame = mat3(tangent, bitangent, normal);
	surf.normal = tangentFrame * bump;
#else
	surf.normal = normal;
#endif
#else
	// pointing directly at the viewer
	surf.normal = vec3(0, 0, 1);
#endif

	// this is crude "baked ambient occulsion" - basically multiply everything by the ambient texture
	// scaling whatever we've decided the lighting contribution is by 0.0 to 1.0 to account for sheltered/hidden surfaces
#ifdef MAP_AMBIENT
	surf.ambientOcclusion = texture(texture3, texCoord0).r;
#else
	surf.ambientOcclusion = 1.0;
#endif

	//emissive only make sense with lighting
#ifdef MAP_EMISSIVE
	// HACK emissive maps are authored weirdly, mostly under the assumption that they will be multiplied by diffuse
	// We mix a litle towards white to make the emissives pop more
	surf.emissive = mix(surf.color.xyz, vec3(1.0), 0.4) * texture(texture2, texCoord0).xyz; //glow map
#else
	surf.emissive = material.emission.xyz; //just emissive parameter
#endif
}

void main(void)
{
	Surface surface;
	getSurface(surface);

#ifdef ALPHA_TEST
	if (surface.color.a < 0.5)
		discard;
#endif

//directional lighting
#if (NUM_LIGHTS > 0)
	//ambient only make sense with lighting
	vec3 diffuse = scene.ambient.xyz * surface.color.xyz;
	vec3 specular = vec3(0.0);
	float intensity[4] = float[](
		scene.lightIntensity.x,
		scene.lightIntensity.y,
		scene.lightIntensity.z,
		scene.lightIntensity.w
	);

	for (int i=0; i<NUM_LIGHTS; ++i) {
		BlinnPhongDirectionalLight(uLight[i], intensity[i], surface, eyePos, diffuse, specular);
	}

	vec3 final_color = diffuse * surface.ambientOcclusion + surface.emissive + specular;
	frag_color = vec4(final_color, surface.color.w);

#ifdef HEAT_COLOURING
	if (heatingAmount > 0.0)
	{
		float dphNn = clamp(dot(heatingNormal, surface.normal), 0.0, 1.0);
		float heatDot = heatingAmount * (dphNn * dphNn * dphNn);
		vec4 heatColour = texture(heatGradient, vec2(heatDot, 0.5)); //heat gradient blend
		frag_color.rgb = frag_color.rgb + heatColour.rgb; // override surface color based on heat color
	}
#endif // HEAT_COLOURING

#else
	frag_color = surface.color;
#endif
}
