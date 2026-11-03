#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>

layout(std140) uniform SkyOccluderInfo {
    float OcclusionStartAngle;
    float OcclusionEndAngle;
};

layout(location = 0) in vec3 viewDirection;

layout(location = 0) out vec4 fragColor;

void main() {
    vec3 worldDirection = normalize(transpose(mat3(ModelViewMat)) * viewDirection);
    float fragmentAngle = degrees(asin(clamp(worldDirection.y, -1.0, 1.0)));
    float alpha = smoothstep(OcclusionStartAngle, OcclusionEndAngle, fragmentAngle);
    fragColor = vec4(ColorModulator.rgb, alpha);
}
