#version 330

#moj_import <minecraft:projection.glsl>

const float OIT_FULLY_OPAQUE_ALPHA = 0.99;
const float OIT_FULLY_OPAQUE_TOTAL_TRANSMITTANCE = 0.02;

float deviceToLinearDepth(float deviceDepth) {
    #ifndef B3D_DEPTH_IS_ZERO_TO_ONE
    deviceDepth = (deviceDepth - 0.5) * 2.0;
    #endif
    float result;
    #ifdef OIT_FORCE_ZERO_DEPTH
    result = 0.0;
    #else
    result = ProjMat[3][2] / (deviceDepth + ProjMat[2][2]);
    #endif
    return result;
}

float toAbsorbance(float transmittance) {
    return clamp(-log(transmittance), 0, 4.0);
}
