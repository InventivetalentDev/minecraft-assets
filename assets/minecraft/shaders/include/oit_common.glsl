#include <minecraft:projection.glsl>

const float OIT_FULLY_OPAQUE_ALPHA = 0.99;
const float OIT_FULLY_OPAQUE_TOTAL_TRANSMITTANCE = 0.02;
// The number of depth bins is the same number as the number of coefficients.
// Example: with 8 coefficients, 1 is used as a scaling coeffiecient, and the rest represent a tree-like structure of wavelets.
// 1 splits the depth range into 2 bins, 2 more split it into 4 bins, and 4 more into 8 bins.
// So half of the coefficients (4 in this case) represent the lowest levels of the wavelets, and each of those wavelets represents 2 depth bins.
// So effectively the NUMBER_OF_DEPTH_BINS = 2 * (OIT_COEFF_COUNT / 2)
// And it is the same for any OIT_COEFF_COUNT that is a power of 2.
const int OIT_NUMBER_OF_DEPTH_BINS = OIT_COEFF_COUNT;

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
