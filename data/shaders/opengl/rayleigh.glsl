float height(const in vec3 orig, const in vec3 center)
{
	vec3 r = orig - center;
	float height = sqrt(dot(r, r)) - geosphereRadius;

	return height;
}

void scatter(out vec2 density, const in vec3 orig, const in vec3 center)
{
	vec2 baricStep = vec2(7994.f, 1200.f);

	float height = height(orig, center);

	density = -height / baricStep;

	// earth atmospheric density: 1.225 kg/m^3, divided by 1e5
	// 1/1.225e-5 = 81632.65306
	float earthDensities = geosphereAtmosFogDensity * 81632.65306f;
	density /= earthDensities;
}

void findClosestHeight(out float h, out float t, const in vec3 orig, const in vec3 dir, const in vec3 center)
{
	vec3 radiusVector = center - orig;
	vec3 tangent = dot(dir, radiusVector) * dir;
	vec3 normal = radiusVector - tangent;
	h = sqrt(dot(normal, normal));
	t = dot(tangent, dir);
}

// error function
float erf(const in float x)
{
	float a = 0.14001228904;
	float four_over_pi = 1.27323954;

	float x2 = x*x;
	float r = -x2 * (four_over_pi + a * x2) / (1 + a * x2);
	if (x > 0)
		return  sqrt(1-exp(r)) * 0.5 + 0.5;
	else
		return -sqrt(1-exp(r)) * 0.5 + 0.5;
}

// predict out-scattering density based on coefficients
float predictDensityOut(const in float atmosphereHeight, const in float height, const in float k, const in float b)
{
	if (height > atmosphereHeight)
		return 0.f;

	// earth atmospheric density: 1.225 kg/m^3, divided by 1e5
	// 1/1.225e-5 = 81632.65306
	float earthDensities = geosphereAtmosFogDensity * 81632.65306f;

	if (height < 0)
		return k / earthDensities;

	return k * exp(-height * b) / earthDensities;
}

// predict in-scattering rate: from 0 to 1
float predictDensityIn(const in float radius, const in float atmosphereHeight, const in float height, const in float c, const in float t)
{
	float minHeight = radius + height;
	float h = sqrt(minHeight*minHeight + t*t); // height for our position

	if (h > radius + atmosphereHeight) {
		if (t > 0)
			return 1.f; // no in-scattering, looking towards atmosphere
		else
			return 0.f; // looking from atmosphere
	} else {
		return erf(c * t); // erf is monotonic ascending
	}
}

float predictDensityInOut(const in vec3 sample, const in vec3 dir, const in vec3 center, const in float radius, const in float atmosphereHeight, const in vec3 coefficients)
{
    float h, t;
    findClosestHeight(h, t, sample, dir, center);
    h -= radius;

    float opticalDepth = 0.f;
    // find out-scattering density
    opticalDepth = predictDensityOut(atmosphereHeight, h, coefficients.x, coefficients.y);

    // apply in-scattering filter
    opticalDepth *= predictDensityIn(radius, atmosphereHeight, h, coefficients.z, t);
    return opticalDepth;
}

void skipRay(inout vec2 opticalDepth, const in vec3 dir, const in vec2 boundaries, const in vec3 center)
{
	int numSamples = 16;

	float tCurrent = boundaries.x;
	float segmentLength = (boundaries.y - boundaries.x) / numSamples;
	for (int i = 0; i < numSamples; ++i) {
		vec3 samplePosition = vec3(tCurrent + segmentLength * 0.5f) * dir;

		// primary ray is approximated by (density * isegmentLength)
		vec2 density;
		scatter(density, samplePosition, center);
		opticalDepth += exp(density) * segmentLength;

		tCurrent += segmentLength;
	}
}

void processRay(inout vec3 sumR, inout vec3 sumM, inout vec2 opticalDepth, const in vec3 sunDirection, const in vec3 dir, const in vec2 boundaries, const in vec3 center)
{
	vec3 betaR = vec3(3.8e-6f, 13.5e-6f, 33.1e-6f);
	vec3 betaM = vec3(21e-6f);

	int numSamples = 16;

	float atmosphereRadius = geosphereRadius * geosphereAtmosTopRad,
	      atmosphereHeight = atmosphereRadius - geosphereRadius;

	float tCurrent = boundaries.x;
	float segmentLength = (boundaries.y - boundaries.x) / numSamples;
	for (int i = 0; i < numSamples; ++i) {
		vec3 samplePosition = vec3(tCurrent + segmentLength * 0.5f) * dir;

		vec2 density;
		scatter(density, samplePosition, center);
		opticalDepth += exp(density) * segmentLength;

		// light optical depth
		vec2 opticalDepthLight = vec2(0.f);
		vec3 samplePositionLight = samplePosition;

		vec3 sampleGeoCenter = center - samplePosition;
		opticalDepthLight.x = predictDensityInOut(samplePositionLight, sunDirection, sampleGeoCenter, geosphereRadius, atmosphereHeight, coefficientsR);
		opticalDepthLight.y = predictDensityInOut(samplePositionLight, sunDirection, sampleGeoCenter, geosphereRadius, atmosphereHeight, coefficientsM);

		vec3 tau = -(betaR * (opticalDepth.x + opticalDepthLight.x) + betaM * 1.1f * (opticalDepth.y + opticalDepthLight.y));
		vec3 tauR = tau + vec3(density.x);
		vec3 tauM = tau + vec3(density.y);
		vec3 attenuationR = exp(tauR) * segmentLength;
		vec3 attenuationM = exp(tauM) * segmentLength;
		sumR += attenuationR;
		sumM += attenuationM;
		tCurrent += segmentLength;
	}
}

vec3 computeIncidentLight(const in vec3 sunDirection, const in vec3 dir, const in vec3 center, const in vec2 atmosDist)
{
	vec3 betaR = vec3(3.8e-6f, 13.5e-6f, 33.1e-6f);
	vec3 betaM = vec3(21e-6f);

	float atmosMin = atmosDist.x * geosphereRadius;
	float atmosMax = atmosDist.y * geosphereRadius;

	// solve Cylinder entry/exit dist
	vec2 cylinder_intersect = rayCylinderIntersect(dir, center, sunDirection, geosphereRadius);
	bool hasIntersect = cylinder_intersect.x != 0 || cylinder_intersect.y != 0;

	vec3 cylinder_near = center - dir * cylinder_intersect.x;
	vec3 cylinder_far  = center - dir * cylinder_intersect.y;

	// test if ray passes through shadow
	float a = dot(cylinder_near, sunDirection);
	float b = dot(cylinder_far , sunDirection);
	bool intersectsShadow = hasIntersect && (a > 0.f || b > 0.f);

	/*
	* We have three options:
	* 1) Ray does not intersect shadow
	*    Do nothing
	* 2) Ray intersects shadow, starts inside
	*    (cylinder_intersect.y, tmax)
	* 3) Ray intersects shadow, starts outside
	*    (tmin, cylinder_intersect.x) + (cylinder_intersect.y, tmax)
	*/

	bool startsInside = raySphereIntersect(center, sunDirection, geosphereRadius).x != 0.f;

	float rayMin = atmosMin;
	float rayMax = atmosMax;
	if (intersectsShadow) {
		rayMin = min(atmosMax, cylinder_intersect.y);
		rayMax = max(atmosMin, cylinder_intersect.x);
	}

	if (rayMin == rayMax)
		return vec3(0.f);

	int numSamples = 16;
	vec3 sumR = vec3(0.0);
	vec3 sumM = vec3(0.0); // mie and rayleigh contribution

	vec2 opticalDepth = vec2(0.f);

	if (atmosMin != rayMax) {
		// process near side of ray
		processRay(sumR, sumM, opticalDepth, sunDirection, dir, vec2(atmosMin, rayMax), center);
	}

	if (atmosMin != rayMin) {
		// calculate optical depth for shadow
		skipRay(opticalDepth, dir, vec2(rayMax, rayMin), center);
	}

	// process far side of ray
	processRay(sumR, sumM, opticalDepth, sunDirection, dir, vec2(rayMin, atmosMax), center);


	float mu = dot(dir, sunDirection); // mu in the paper which is the cosine of the angle between the sun direction and the ray direction
	float phaseR = 3.f / (16.f * 3.141592) * (1 + mu * mu);
	float g = 0.76f;
	float phaseM = 3.f / (8.f * 3.141592) * ((1.f - g * g) * (1.f + mu * mu)) / ((2.f + g * g) * pow(1.f + g * g - 2.f * g * mu, 1.5f));

	vec3 ret = (sumR * betaR * phaseR + sumM * betaM * phaseM);
	return ret;
}
