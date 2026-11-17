#version 330
#extension GL_ARB_separate_shader_objects : require

layout (input_attachment_index = 0) uniform subpassInput DepthBoundsSampler;

layout(location = 0) in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

void main() {
    fragColor = subpassLoad(DepthBoundsSampler);
}
