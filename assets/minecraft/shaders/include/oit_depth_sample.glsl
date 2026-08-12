uniform sampler2D DepthBoundsSampler;

const float OIT_HIGH_PRECISION_DEPTH_THRESHOLD = 10.0;
const int OIT_LOW_PRECISION_DEPTH_BINS = 2;

float normalizeDepth(float fragmentDeviceDepth) {
    vec4 depthBoundsSample = texelFetch(DepthBoundsSampler, ivec2(gl_FragCoord.xy), 0);
    float closestBoundLinearDepthNegated = depthBoundsSample.r;
    float closestBoundLinearDepth = -closestBoundLinearDepthNegated;
    float furthestBoundLinearDepth = depthBoundsSample.g;

    float fragmentLinearDepth = deviceToLinearDepth(fragmentDeviceDepth);
    float range = max(furthestBoundLinearDepth - closestBoundLinearDepth, 0.0001);
    float depthWithinBounds = clamp(fragmentLinearDepth - closestBoundLinearDepth, 0.0, range);

    const float depthFractionWithHighPrecision = float(OIT_NUMBER_OF_DEPTH_BINS - OIT_LOW_PRECISION_DEPTH_BINS) / float(OIT_NUMBER_OF_DEPTH_BINS);
    float depthWithHighPrecision = depthFractionWithHighPrecision * range;

    if (depthWithHighPrecision <= OIT_HIGH_PRECISION_DEPTH_THRESHOLD) {
        return depthWithinBounds / range;
    } else if (depthWithinBounds <= OIT_HIGH_PRECISION_DEPTH_THRESHOLD) {
        return (depthWithinBounds / OIT_HIGH_PRECISION_DEPTH_THRESHOLD) * depthFractionWithHighPrecision;
    } else {
        return depthFractionWithHighPrecision + ((depthWithinBounds - OIT_HIGH_PRECISION_DEPTH_THRESHOLD) / (range - OIT_HIGH_PRECISION_DEPTH_THRESHOLD)) * (1.0 - depthFractionWithHighPrecision);
    }
}
