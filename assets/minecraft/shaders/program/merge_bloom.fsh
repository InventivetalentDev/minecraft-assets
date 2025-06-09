#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D BloomSampler;
uniform sampler2D HighlightsSampler;

uniform float BloomFactor;
uniform float HighlightsFactor;
uniform float Thirst;

in vec2 texCoord;

out vec4 fragColor;

void main() {
    vec4 color = texture(DiffuseSampler, texCoord);
    vec4 bloom = texture(BloomSampler, texCoord);
    vec4 highlights = texture(HighlightsSampler, texCoord);
    float brightness = max(bloom.r * BloomFactor, highlights.r * HighlightsFactor);
    float thirstFactor = (1.0 - Thirst) * 0.5 + 1.0;
    fragColor = vec4(mix(color.rgb, vec3(1.0), brightness * thirstFactor), 1.0);
}
