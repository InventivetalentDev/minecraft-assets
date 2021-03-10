#version 150

flat in vec4 vertexColor;

out vec4 fragColor;

void main() {
    fragColor = vertexColor;
}
