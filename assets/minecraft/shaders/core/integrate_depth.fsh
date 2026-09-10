#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;

layout(location = 0) in vec2 texCoord;

void main() {
    float depth = texelFetch(InSampler, ivec2(gl_FragCoord.xy), 0).r;

    if (depth == 0.0) {
        discard;
    }

    gl_FragDepth = depth;
}
