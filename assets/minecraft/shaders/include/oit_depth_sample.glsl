uniform sampler2D DepthBoundsSampler;

const float OIT_HIGH_PRECISION_DEPTH_THRESHOLD = 10.0;
const int OIT_LOW_PRECISION_COEFF_COUNT = 2;

float normalizeDepth(float fragmentDeviceDepth) {
    vec4 depthBoundsSample = texelFetch(DepthBoundsSampler, ivec2(gl_FragCoord.xy), 0);
    float closestBoundLinearDepthNegated = depthBoundsSample.r;
    float closestBoundLinearDepth = -closestBoundLinearDepthNegated;
    float furthestBoundLinearDepth = depthBoundsSample.g;

    float fragmentLinearDepth = deviceToLinearDepth(fragmentDeviceDepth);
    float range = max(furthestBoundLinearDepth - closestBoundLinearDepth, 0.0001);
    float depthWithinBounds = clamp(fragmentLinearDepth - closestBoundLinearDepth, 0.0, range);

    const float depthFractionWithHighPrecision = float(COEFF_COUNT - OIT_LOW_PRECISION_COEFF_COUNT) / float(COEFF_COUNT);
    float depthWithHighPrecision = depthFractionWithHighPrecision * range;

    float mappedDepth;
    if (depthWithHighPrecision <= OIT_HIGH_PRECISION_DEPTH_THRESHOLD) {
        mappedDepth = depthWithinBounds / range;
    } else if (depthWithinBounds <= OIT_HIGH_PRECISION_DEPTH_THRESHOLD) {
        mappedDepth = (depthWithinBounds / OIT_HIGH_PRECISION_DEPTH_THRESHOLD) * depthFractionWithHighPrecision;
    } else {
        mappedDepth = depthFractionWithHighPrecision + ((depthWithinBounds - OIT_HIGH_PRECISION_DEPTH_THRESHOLD) / (range - OIT_HIGH_PRECISION_DEPTH_THRESHOLD)) * (1.0 - depthFractionWithHighPrecision);
    }

    return mappedDepth * (1.0 - 1.0 / COEFF_COUNT);
}
