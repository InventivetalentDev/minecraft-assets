#version 330

uniform samplerCube Sampler0;

in vec3 texCoord0;

out vec4 fragColor;

void main() {
    fragColor = texture(Sampler0, texCoord0);
}
