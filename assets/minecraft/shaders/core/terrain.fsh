#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:globals.glsl>
#include <minecraft:texture_sampling.glsl>
#include <minecraft:oit.glsl>
#include <minecraft:terrainglobals.glsl>
#ifndef MULTIDRAW_TERRAIN
    #include <minecraft:chunksection.glsl>
#endif

uniform sampler2D Sampler0;
#ifdef IMPROVED_FOG
uniform sampler2D SkySampler;
uniform sampler2D CloudsSampler;
uniform sampler2D CloudsDepthSampler;
#endif

layout(location = 0) in float sphericalVertexDistance;
layout(location = 1) in float cylindricalVertexDistance;
layout(location = 2) in vec4 vertexColor;
layout(location = 3) in vec2 texCoord0;
layout(location = 4) in float chunkVisibility;

#ifndef OIT_ALPHA_ONLY
layout(location = 0) out vec4 fragColor;
#endif

const float ENVIRONMENTAL_BACKGROUND_BLEND_START = 0.9;

#ifdef IMPROVED_FOG
vec3 sampleBackgroundColor(ivec2 pixelCoords) {
    vec3 skyColor = texelFetch(SkySampler, pixelCoords, 0).rgb;
    vec4 cloudColor = texelFetch(CloudsSampler, pixelCoords, 0);
    float cloudDepth = texelFetch(CloudsDepthSampler, pixelCoords, 0).r;
    float cloudsBehind = step(cloudDepth, gl_FragCoord.z);
    return mix(skyColor, cloudColor.rgb / (cloudColor.a > 0.0 ? cloudColor.a : 1.0), cloudColor.a * cloudsBehind);
}
#endif

#ifndef OIT_ALPHA_ONLY
vec4 calculateFinalColor(vec4 color) {
    float environmentalValue = linear_fog_value(sphericalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd);
    float renderDistanceValue = linear_fog_value(cylindricalVertexDistance, FogRenderDistanceStart, FogRenderDistanceEnd);

    float environmentalBackgroundValue = smoothstep(ENVIRONMENTAL_BACKGROUND_BLEND_START, 1.0, environmentalValue);

    float fogValue = max(environmentalValue, renderDistanceValue);

    float backgroundFogValue = max(environmentalBackgroundValue, renderDistanceValue);

    if (backgroundFogValue > 0.0 || chunkVisibility < 1.0) {
        #ifdef IMPROVED_FOG
        vec3 backgroundColor = sampleBackgroundColor(ivec2(gl_FragCoord.xy));
        vec3 targetColor = mix(FogColor.rgb, backgroundColor, backgroundFogValue);
        #else
        vec3 backgroundColor = FogColor.rgb;
        vec3 targetColor = backgroundColor;
        #endif
        vec3 foggedColor = mix(color.rgb, targetColor, fogValue);
        vec3 foggedFadedColor = mix(backgroundColor, foggedColor, chunkVisibility);
        color = vec4(foggedFadedColor, color.a);
    } else {
        color.rgb = mix(color.rgb, FogColor.rgb, fogValue);
    }
    #ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color);
    #endif

    return color;
}
#endif

void main() {
    vec4 color = (UseRgss == 1 ? sampleRGSS(Sampler0, texCoord0, 1.0f / TextureSize) : sampleNearest(Sampler0, texCoord0, 1.0f / TextureSize)) * vertexColor;
    #ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
    #endif

    #ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
    #else
    fragColor = calculateFinalColor(color);
    #endif
}
