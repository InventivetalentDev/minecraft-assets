#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>


layout(location = 0) in float sphericalVertexDistance;
layout(location = 1) in float cylindricalVertexDistance;
layout(location = 2) flat in vec4 vertexColor;

layout(location = 0) out vec4 fragColor;

void main() {
    fragColor = apply_fog(vertexColor, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
