#ifndef MINECRAFT_OIT_ADD_TRANSMITTANCE_GLSL
#define MINECRAFT_OIT_ADD_TRANSMITTANCE_GLSL

layout(location = 0) out vec4 bins[OIT_TRANSMITTANCE_TARGET_COUNT];

void addTransmittance(float transmittance) {
    float absorbance = toAbsorbance(transmittance);

    float depthBinIndexF = normalizeDepth(gl_FragCoord.z) * float(OIT_NUMBER_OF_DEPTH_BINS - 1);
    int depthBinIndex = int(floor(depthBinIndexF));

    float absorbanceInThisBin = absorbance * (1.0 - fract(depthBinIndexF));

    for (int attachmentIndex = 0; attachmentIndex < OIT_TRANSMITTANCE_TARGET_COUNT; attachmentIndex++) {
        for (int i = 0; i < 4; i++) {
            int outputDepthBinIndex = attachmentIndex * 4 + i;
            bins[attachmentIndex][i] = outputDepthBinIndex > depthBinIndex
                ? absorbance
                : (outputDepthBinIndex == depthBinIndex ? absorbanceInThisBin : 0.0);
        }
    }
    #ifdef RENDERPEARL_EXPLICIT_DEPTH_INVARIANCE
    gl_FragDepth = gl_FragCoord.z;
    #endif
}

#endif
