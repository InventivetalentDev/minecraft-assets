#version 330

uniform sampler2D Coeff0;
#if COEFF_COUNT > 4
uniform sampler2D Coeff1;
#endif
#if COEFF_COUNT > 8
uniform sampler2D Coeff2;
uniform sampler2D Coeff3;
#endif

float evaluateWaveletsCorrected(float coefficients[COEFF_COUNT], float depth, float currentAbsorbance) {
    float scaleCoeff = coefficients[COEFF_COUNT - 1];
    if (scaleCoeff == 0) {
        return 0.0;
    }
    float scaleCoeffAddend = (currentAbsorbance * -depth) + currentAbsorbance;
    scaleCoeff -= scaleCoeffAddend;

    depth *= float(COEFF_COUNT - 1) / COEFF_COUNT;

    float coeffDepth = depth * COEFF_COUNT;
    int indexB = clamp(int(floor(coeffDepth)), 0, COEFF_COUNT - 1);
    bool sampleA = indexB >= 1;
    int indexA = sampleA ? (indexB - 1) : indexB;

    indexB += COEFF_COUNT - 1;
    indexA += COEFF_COUNT - 1;

    float b = scaleCoeff;
    float a = sampleA ? scaleCoeff : 0;

    for (int i = 0; i < WAVELET_RANK + 1; i++) {
        int power = WAVELET_RANK - i;

        int newIndexB = (indexB - 1) >> 1;
        int waveletSignB = ((indexB & 1) << 1) - 1;
        float coeffB = coefficients[newIndexB];

        float waveletPhaseB = ((indexB + 1) & 1) * exp2(-power);
        float k = float((newIndexB + 1) & ((1 << power) - 1));
        float addend = ((depth - exp2(-power) * k) * waveletSignB + waveletPhaseB) * exp2(power * 0.5) * currentAbsorbance;
        coeffB -= addend;

        b -= exp2(power * 0.5) * coeffB * waveletSignB;
        indexB = newIndexB;

        if (sampleA) {
            int newIndexA = (indexA - 1) >> 1;
            int waveletSignA = ((indexA & 1) << 1) - 1;
            float coeffA = (newIndexA == newIndexB) ? coeffB : coefficients[newIndexA];
            a -= exp2(power * 0.5) * coeffA * waveletSignA;
            indexA = newIndexA;
        }
    }

    float t = coeffDepth >= COEFF_COUNT ? 1.0 : fract(coeffDepth);

    return mix(a, b, t);
}

float sampleTransmittance(ivec2 pos, float depth, float currentAbsorbance) {
    float coefficients[COEFF_COUNT];
    const int targetCount = COEFF_COUNT / 4;
    vec4 coeffSamples[targetCount];
    coeffSamples[0] = texelFetch(Coeff0, pos, 0);
    #if COEFF_COUNT > 4
    coeffSamples[1] = texelFetch(Coeff1, pos, 0);
    #endif
    #if COEFF_COUNT > 8
    coeffSamples[2] = texelFetch(Coeff2, pos, 0);
    coeffSamples[3] = texelFetch(Coeff3, pos, 0);
    #endif
    for (int i = 0; i < targetCount; i++) {
        for (int j = 0; j < 4; j++) {
            coefficients[i * 4 + j] = coeffSamples[i][j];
        }
    }
    return clamp(exp(-evaluateWaveletsCorrected(coefficients, depth, currentAbsorbance)), 0.0001, 1.0);
}

#ifdef OIT_ACCUMULATE
vec4 sampleColorForAccumulation(vec4 color) {
    #ifdef OIT_ADDITIVE
    float transmittance = 1.0;
    float absorbance = 0.0;
    float accumAlpha = 0.0;
    #else
    float transmittance = 1.0 - color.a;
    float absorbance = toAbsorbance(transmittance);
    float accumAlpha = color.a;
    #endif
    float sampledTransmittance = sampleTransmittance(ivec2(gl_FragCoord.xy), normalizeDepth(gl_FragCoord.z, transmittance), absorbance);
    return vec4(color.rgb * color.a, accumAlpha) * sampledTransmittance;
}
#endif
