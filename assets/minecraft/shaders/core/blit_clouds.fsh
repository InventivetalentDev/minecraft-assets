#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:oit.glsl>

uniform sampler2D InSampler;
uniform sampler2D InDepthSampler;

layout(location = 0) in vec2 texCoord;

#ifndef OIT_ALPHA_ONLY
layout(location = 0) out vec4 fragColor;
#endif

vec4 calculateFinalColor(vec4 color, float deviceDepth) {
    #ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color, deviceDepth);
    #endif
    return color;
}

void main() {
    ivec2 pixelCoords = ivec2(gl_FragCoord.xy);
    vec4 color = texelFetch(InSampler, pixelCoords, 0);
    if (color.a <= 0.0) {
        discard;
    }

    color.rgb /= color.a;

    float cloudDepth = texelFetch(InDepthSampler, pixelCoords, 0).r;
    gl_FragDepth = cloudDepth;

    #ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(cloudDepth, color.a);
    #else
    fragColor = calculateFinalColor(color, cloudDepth);
    #endif
}
