#version 330

uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform InvertConfig {
    float InverseAmount;
};

out vec4 fragColor;

void main(){
    vec2 sizeRatio = OutSize / InSize;

    vec4 diffuseColor = texture(InSampler, texCoord);
    vec4 invertColor = 1.0 - diffuseColor;
    vec4 outColor = mix(diffuseColor, invertColor, InverseAmount);
    fragColor = vec4(outColor.rgb, 1.0);
}
