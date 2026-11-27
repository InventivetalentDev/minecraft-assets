#ifndef MINECRAFT_OIT_COMMON_GLSL
#define MINECRAFT_OIT_COMMON_GLSL

#include <minecraft:projection.glsl>

const float OIT_FULLY_OPAQUE_ALPHA = 0.99;
const float OIT_FULLY_OPAQUE_TOTAL_TRANSMITTANCE = 0.02;

float deviceToLinearDepth(float deviceDepth) {
    #ifndef RENDERPEARL_DEPTH_IS_ZERO_TO_ONE
    deviceDepth = (deviceDepth - 0.5) * 2.0;
    #endif
    return ProjMat[3][2] / (deviceDepth + ProjMat[2][2]);
}

float toAbsorbance(float transmittance) {
    return clamp(-log(max(transmittance, 0.0001)), 0, 4.0);
}

float toTransmittance(float absorbance) {
    return clamp(exp(-absorbance), 0.0001, 1.0);
}

#endif
