out vec2 fragColor;

void calculateDepthBounds(float deviceDepth) {
    float depth = deviceToLinearDepth(deviceDepth);
    fragColor = vec2(-depth, depth);
}
