#version 330

#moj_import <minecraft:oit_common.glsl>

uniform sampler2D DepthBoundsSampler;

in vec2 texCoord;

out vec4 fragColor;

void main() {
    ivec2 pixelCoords = ivec2(gl_FragCoord.xy);
    vec4 depthBounds = texelFetch(DepthBoundsSampler, pixelCoords, 0);

    float closestBoundLinearDepthNegated = depthBounds.r;
    float furthestBoundLinearDepth = depthBounds.g;
    float closestBoundDeviceDepth = depthBounds.b;
    float opaqueOitDeviceDepth = depthBounds.a;

    float opaqueOitLinearDepth = deviceToLinearDepth(opaqueOitDeviceDepth);


    fragColor = vec4(closestBoundLinearDepthNegated, min(furthestBoundLinearDepth, opaqueOitLinearDepth), closestBoundDeviceDepth, opaqueOitDeviceDepth);
    gl_FragDepth = opaqueOitDeviceDepth;
}
