#version 330

uniform sampler2D InSampler;

layout(std140) uniform BlitConfig {
    vec4 ColorModulate;
};

in vec2 texCoord;

out vec4 fragColor;

void main(){
    fragColor = texture(InSampler, texCoord) * ColorModulate;
}
