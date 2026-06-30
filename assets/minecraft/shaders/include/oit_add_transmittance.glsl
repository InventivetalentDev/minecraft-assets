#version 330

layout(location = 0) out vec4 coeff[COEFF_ATTACHMENT_COUNT];

void addTransmittance(float alpha) {
    float transmittance = 1.0 - alpha;
    float absorbance = toAbsorbance(transmittance);

    float depth = normalizeDepth(gl_FragCoord.z, transmittance);

    float coefficients[COEFF_COUNT];
    for (int i = 0; i < COEFF_COUNT; i++) {
        coefficients[i] = 0;
    }

    depth *= float(COEFF_COUNT - 1) / COEFF_COUNT;

    int index = clamp(int(floor(depth * COEFF_COUNT)), 0, COEFF_COUNT - 1);
    index += COEFF_COUNT - 1;

    for (int i = 0; i < (WAVELET_RANK + 1); i++) {
        int power = WAVELET_RANK - i;
        int newIndex = (index - 1) >> 1;
        float k = float((newIndex + 1) & ((1 << power) - 1));

        int waveletSign = ((index & 1) << 1) - 1;
        float waveletPhase = ((index + 1) & 1) * exp2(-power);
        float addend = ((depth - exp2(-power) * k) * waveletSign + waveletPhase) * exp2(power * 0.5) * absorbance;
        coefficients[newIndex] = addend;

        index = int(newIndex);
    }

    float addend = absorbance - (absorbance * depth);
    coefficients[COEFF_COUNT - 1] = addend;

    for (int attachmentIndex = 0; attachmentIndex < COEFF_ATTACHMENT_COUNT; attachmentIndex++) {
        for (int i = 0; i < 4; i++) {
            coeff[attachmentIndex][i] = coefficients[attachmentIndex * 4 + i];
        }
    }
}
