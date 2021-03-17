#version 150

in vec4 vertexColor;

uniform vec4 ColorModulator;

out vec4 fragColor;

void main() {
    fragColor = vertexColor * ColorModulator;
}
