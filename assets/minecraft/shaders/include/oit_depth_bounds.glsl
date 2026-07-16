out vec4 fragColor;

void calculateDepthBounds(float fragmentDeviceDepth, float alpha) {
    float fragmentLinearDepth = deviceToLinearDepth(fragmentDeviceDepth);
    float opaqueFragmentDeviceDepth = alpha > OIT_FULLY_OPAQUE_ALPHA ? fragmentDeviceDepth : 0.0;
    fragColor = vec4(-fragmentLinearDepth, fragmentLinearDepth, fragmentDeviceDepth, opaqueFragmentDeviceDepth);
}
