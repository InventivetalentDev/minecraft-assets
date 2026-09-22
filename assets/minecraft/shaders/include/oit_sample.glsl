#ifndef MINECRAFT_OIT_SAMPLE_GLSL
#define MINECRAFT_OIT_SAMPLE_GLSL

uniform sampler2D Bins0;
#if OIT_TRANSMITTANCE_TARGET_COUNT > 1
uniform sampler2D Bins1;
#endif
#if OIT_TRANSMITTANCE_TARGET_COUNT > 2
uniform sampler2D Bins2;
#endif
#if OIT_TRANSMITTANCE_TARGET_COUNT > 3
uniform sampler2D Bins3;
#endif

float sampleAbsorbance(float bins[OIT_NUMBER_OF_DEPTH_BINS], float originalDepth, float currentAbsorbance) {
    float totalAbsorbance = bins[OIT_NUMBER_OF_DEPTH_BINS - 1];
    if (totalAbsorbance == 0) {
        return 0.0;
    }

    float depthMeasuredInBins = originalDepth * (OIT_NUMBER_OF_DEPTH_BINS - 1);
    float depthWithinBin = fract(depthMeasuredInBins);

    int indexB = clamp(int(floor(depthMeasuredInBins)), 0, OIT_NUMBER_OF_DEPTH_BINS - 1);
    bool shouldSampleA = indexB >= 1;
    int indexA = shouldSampleA ? (indexB - 1) : indexB;

    // B is the sample at the depth bin that the fragment is in, and A is the sample at the depth bin just before it.
    float sampleB = bins[indexB] - currentAbsorbance * (1.0 - depthWithinBin);
    float sampleA = shouldSampleA ? bins[indexA] : 0.0;

    float lerpAlpha = depthMeasuredInBins >= OIT_NUMBER_OF_DEPTH_BINS ? 1.0 : depthWithinBin;

    return mix(sampleA, sampleB, lerpAlpha);
}

float sampleTransmittance(ivec2 pos, float depth, float currentTransmittance) {
    float bins[OIT_NUMBER_OF_DEPTH_BINS];
    vec4 binsSamples[OIT_TRANSMITTANCE_TARGET_COUNT];
    binsSamples[0] = texelFetch(Bins0, pos, 0);
    #if OIT_TRANSMITTANCE_TARGET_COUNT > 1
    binsSamples[1] = texelFetch(Bins1, pos, 0);
    #endif
    #if OIT_TRANSMITTANCE_TARGET_COUNT > 2
    binsSamples[2] = texelFetch(Bins2, pos, 0);
    #endif
    #if OIT_TRANSMITTANCE_TARGET_COUNT > 3
    binsSamples[3] = texelFetch(Bins3, pos, 0);
    #endif
    for (int i = 0; i < OIT_TRANSMITTANCE_TARGET_COUNT; i++) {
        for (int j = 0; j < 4; j++) {
            bins[i * 4 + j] = binsSamples[i][j];
        }
    }
    return toTransmittance(sampleAbsorbance(bins, depth, toAbsorbance(currentTransmittance)));
}

#ifdef OIT_ACCUMULATE
vec4 sampleColorForAccumulation(vec4 color) {
    #ifdef OIT_ADDITIVE
    float transmittance = 1.0;
    float accumAlpha = 0.0;
    #else
    float transmittance = 1.0 - color.a;
    float accumAlpha = color.a;
    #endif
    #ifdef RENDERPEARL_EXPLICIT_DEPTH_INVARIANCE
    gl_FragDepth = gl_FragCoord.z;
    #endif
    float sampledTransmittance = sampleTransmittance(ivec2(gl_FragCoord.xy), normalizeDepth(gl_FragCoord.z), transmittance);
    return vec4(color.rgb * color.a, accumAlpha) * sampledTransmittance;
}
#endif

#endif
