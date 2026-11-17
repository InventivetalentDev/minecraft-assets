#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:oit_common.glsl>

layout (input_attachment_index = 0) uniform subpassInput DepthBoundsSampler;

layout(location = 0) in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

void main() {
    vec4 depthBounds = subpassLoad(DepthBoundsSampler);

    float closestBoundLinearDepthNegated = depthBounds.r;
    float furthestBoundLinearDepth = depthBounds.g;
    float closestBoundDeviceDepth = depthBounds.b;
    float opaqueOitDeviceDepth = depthBounds.a;

    float opaqueOitLinearDepth = deviceToLinearDepth(opaqueOitDeviceDepth);

    fragColor = vec4(closestBoundLinearDepthNegated, min(furthestBoundLinearDepth, opaqueOitLinearDepth), closestBoundDeviceDepth, opaqueOitDeviceDepth);
    gl_FragDepth = opaqueOitDeviceDepth;
}
