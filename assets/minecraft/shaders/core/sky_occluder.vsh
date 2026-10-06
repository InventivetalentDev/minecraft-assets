#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>
#include <minecraft:fullscreen_triangle.glsl>

layout(location = 0) out vec3 viewDirection;

const float NEAR_PLANE_DEPTH = 1.0;
const float FAR_PLANE_DEPTH = 0.0;

vec3 unproject(mat4 inverseProjection, vec4 position) {
    vec4 unprojected = inverseProjection * position;
    return unprojected.xyz / unprojected.w;
}

void main() {
    vec2 position = fullscreen_triangle_position();

    gl_Position = vec4(position, NEAR_PLANE_DEPTH, 1.0);

    mat4 inverseProjection = inverse(ProjMat);
    // Sample at 2 depths and get a difference to get rid of the translation component of the projection matrix caused by view bobbing.
    viewDirection = unproject(inverseProjection, vec4(position, FAR_PLANE_DEPTH, 1.0)) - unproject(inverseProjection, vec4(position, NEAR_PLANE_DEPTH, 1.0));
}
