#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

void main() {
    gl_FragDepth = texture(InSampler, texCoord).r;
}
