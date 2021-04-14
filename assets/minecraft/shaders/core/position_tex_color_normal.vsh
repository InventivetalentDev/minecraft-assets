#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;
out float vertexDistance;
out vec4 vertexColor;
out vec4 normal;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    texCoord0 = UV0;
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
