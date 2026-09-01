layout(location = 0) out vec4 coeff[OIT_COEFF_ATTACHMENT_COUNT];

void addTransmittance(float transmittance) {
    float coefficients[OIT_COEFF_COUNT];
    for (int i = 0; i < OIT_COEFF_COUNT; i++) {
        coefficients[i] = 0;
    }

    float absorbance = toAbsorbance(transmittance);

    float originalDepth = normalizeDepth(gl_FragCoord.z);
    float depth = originalDepth * float(OIT_NUMBER_OF_DEPTH_BINS - 1) / OIT_NUMBER_OF_DEPTH_BINS;

    float averageAbsorbance = absorbance * (1 - depth);
    coefficients[0] = averageAbsorbance;

    int depthBinIndex = int(floor(originalDepth * (OIT_NUMBER_OF_DEPTH_BINS - 1)));
    // The tree starts at the coefficient 1
    int treeIndex = depthBinIndex + OIT_COEFF_COUNT;

    for (int waveletLevel = 0; waveletLevel <= OIT_WAVELET_RANK; waveletLevel++) {
        int power = OIT_WAVELET_RANK - waveletLevel;
        int parentIndex = treeIndex >> 1;
        float indexAtParentLevel = float(parentIndex & ((1 << power) - 1));

        int isRightHalf = treeIndex & 1;
        int waveletSign = 1 - (isRightHalf << 1);
        float waveletWidth = exp2(-power);
        float waveletHeightScale = exp2(power * 0.5);
        float depthOffsetRelativeToWavelet = depth - waveletWidth * indexAtParentLevel;
        float distanceFromWaveletEdge = isRightHalf * waveletWidth + waveletSign * depthOffsetRelativeToWavelet;
        float differenceCoefficient = distanceFromWaveletEdge * waveletHeightScale * absorbance;
        coefficients[parentIndex] = differenceCoefficient;

        treeIndex = parentIndex;
    }

    for (int attachmentIndex = 0; attachmentIndex < OIT_COEFF_ATTACHMENT_COUNT; attachmentIndex++) {
        for (int i = 0; i < 4; i++) {
            coeff[attachmentIndex][i] = coefficients[attachmentIndex * 4 + i];
        }
    }
    #ifdef RENDERPEARL_EXPLICIT_DEPTH_INVARIANCE
    gl_FragDepth = gl_FragCoord.z;
    #endif
}
