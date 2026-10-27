#version 330
#extension GL_ARB_separate_shader_objects : require

uniform samplerCube Sampler0;

layout(location = 0) in vec3 texCoord0;

layout(location = 0) out vec4 fragColor;

void main() {
    fragColor = texture(Sampler0, texCoord0);
}
