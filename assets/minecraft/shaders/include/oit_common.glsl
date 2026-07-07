#version 330

#moj_import <minecraft:projection.glsl>

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
    return max(-log(max(transmittance, 0.00001)), -0.1);
}
