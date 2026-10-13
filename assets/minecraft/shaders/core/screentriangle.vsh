#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fullscreen_triangle.glsl>

layout(location = 0) out vec2 texCoord;

void main() {
    vec2 position = fullscreen_triangle_position();
    #ifdef RENDERPEARL_DEPTH_IS_ZERO_TO_ONE
    float z = 0.0;
    #else
    float z = -1.0;
    #endif
    gl_Position = vec4(position, z, 1.0);
    texCoord = position * 0.5 + 0.5;
}
