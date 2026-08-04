uniform sampler2D Coeff0;
#if OIT_COEFF_COUNT > 4
uniform sampler2D Coeff1;
#endif
#if OIT_COEFF_COUNT > 8
uniform sampler2D Coeff2;
uniform sampler2D Coeff3;
#endif

float sampleAbsorbance(float coefficients[OIT_COEFF_COUNT], float originalDepth, float currentAbsorbance) {
    float averageAbsorbance = coefficients[0];
    if (averageAbsorbance == 0) {
        return 0.0;
    }
    float currentAverageAbsorbanceContribution = currentAbsorbance * (1 - originalDepth);
    averageAbsorbance -= currentAverageAbsorbanceContribution;

    float depthMeasuredInBins = originalDepth * (OIT_NUMBER_OF_DEPTH_BINS - 1);

    float depth = depthMeasuredInBins / OIT_NUMBER_OF_DEPTH_BINS;

    int treeIndexB = clamp(int(floor(depthMeasuredInBins)), 0, OIT_NUMBER_OF_DEPTH_BINS - 1);
    bool shouldSampleA = treeIndexB >= 1;
    int treeIndexA = shouldSampleA ? (treeIndexB - 1) : treeIndexB;

    treeIndexB += OIT_COEFF_COUNT;
    treeIndexA += OIT_COEFF_COUNT;

    // B is the sample at the depth bin that the fragment is in, and A is the sample at the depth bin just before it.

    float sampleB = averageAbsorbance;
    float sampleA = shouldSampleA ? averageAbsorbance : 0;

    for (int waveletLevel = 0; waveletLevel <= OIT_WAVELET_RANK; waveletLevel++) {
        int power = OIT_WAVELET_RANK - waveletLevel;
        float waveletWidth = exp2(-power);
        float waveletHeightScale = exp2(power * 0.5);

        int parentIndexB = treeIndexB >> 1;
        int isRightHalfB = treeIndexB & 1;
        int waveletSignB = 1 - (isRightHalfB << 1);

        float indexAtParentLevel = float(parentIndexB & ((1 << power) - 1));
        float depthOffsetRelativeToWavelet = depth - waveletWidth * indexAtParentLevel;
        float currentDifferenceCoefficient = (isRightHalfB * waveletWidth + waveletSignB * depthOffsetRelativeToWavelet) * waveletHeightScale * currentAbsorbance;

        float differenceCoefficientB = coefficients[parentIndexB];
        differenceCoefficientB -= currentDifferenceCoefficient;

        sampleB -= waveletHeightScale * differenceCoefficientB * waveletSignB;
        treeIndexB = parentIndexB;

        if (shouldSampleA) {
            int parentIndexA = treeIndexA >> 1;
            float differenceCoefficientA = (parentIndexA == parentIndexB) ? differenceCoefficientB : coefficients[parentIndexA];
            int isRightHalfA = treeIndexA & 1;
            int waveletSignA = 1 - (isRightHalfA << 1);
            sampleA -= waveletHeightScale * differenceCoefficientA * waveletSignA;
            treeIndexA = parentIndexA;
        }
    }

    float lerpAlpha = depthMeasuredInBins >= OIT_NUMBER_OF_DEPTH_BINS ? 1.0 : fract(depthMeasuredInBins);

    return mix(sampleA, sampleB, lerpAlpha);
}

float sampleTransmittance(ivec2 pos, float depth, float currentTransmittance) {
    float coefficients[OIT_COEFF_COUNT];
    const int targetCount = OIT_COEFF_COUNT / 4;
    vec4 coeffSamples[targetCount];
    coeffSamples[0] = texelFetch(Coeff0, pos, 0);
    #if OIT_COEFF_COUNT > 4
    coeffSamples[1] = texelFetch(Coeff1, pos, 0);
    #endif
    #if OIT_COEFF_COUNT > 8
    coeffSamples[2] = texelFetch(Coeff2, pos, 0);
    coeffSamples[3] = texelFetch(Coeff3, pos, 0);
    #endif
    for (int i = 0; i < targetCount; i++) {
        for (int j = 0; j < 4; j++) {
            coefficients[i * 4 + j] = coeffSamples[i][j];
        }
    }
    return toTransmittance(sampleAbsorbance(coefficients, depth, toAbsorbance(currentTransmittance)));
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
