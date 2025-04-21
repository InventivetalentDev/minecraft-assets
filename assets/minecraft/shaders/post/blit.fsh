#version 150

uniform sampler2D InSampler;

uniform vec4 ColorModulate;

in vec2 texCoord;

out vec4 fragColor;

void main(){
    fragColor = texture(InSampler, texCoord) * ColorModulate;
}
