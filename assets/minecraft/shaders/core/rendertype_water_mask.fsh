#version 330
#extension GL_ARB_separate_shader_objects : require

layout(location = 0) out float fragColor;

void main() {
    fragColor = gl_FragCoord.z;
}
