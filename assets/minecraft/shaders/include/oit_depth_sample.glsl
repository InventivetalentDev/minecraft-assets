uniform sampler2D DepthBoundsSampler;

float normalizeDepth(float depth, float transmittance) {
    float linearDepth = deviceToLinearDepth(depth);
    vec2 depthBoundsSample = texelFetch(DepthBoundsSampler, ivec2(gl_FragCoord.xy), 0).xy;
    vec2 depthBounds = vec2(-depthBoundsSample.x, depthBoundsSample.y);

    float range = max(depthBounds.y - depthBounds.x, 0.0001);
    float distance = linearDepth - depthBounds.x;
    return max(clamp(distance / range, 0.0, 1.0) * (1.0 - 1.0 / COEFF_COUNT), 0.0);
}
