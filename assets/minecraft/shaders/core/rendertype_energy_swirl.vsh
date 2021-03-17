#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in vec2 UV2;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat4 TextureMat;

out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexColor = Color;
    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
