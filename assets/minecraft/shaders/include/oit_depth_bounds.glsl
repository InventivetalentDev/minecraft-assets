out vec4 fragColor;

void calculateDepthBounds(float deviceDepth) {
    float depth = deviceToLinearDepth(deviceDepth);
    fragColor = vec4(-depth, depth, deviceDepth, 0.0);
}
