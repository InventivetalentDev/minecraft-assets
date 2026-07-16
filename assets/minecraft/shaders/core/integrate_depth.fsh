#version 330

uniform sampler2D InSampler;

in vec2 texCoord;

void main() {
    float depth = texelFetch(InSampler, ivec2(gl_FragCoord.xy), 0).r;

    if (depth == 0.0) {
        discard;
    }

    gl_FragDepth = depth;
}
