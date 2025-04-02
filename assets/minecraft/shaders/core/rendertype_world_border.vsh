#version 150

in vec3 Position;
in vec2 UV0;

uniform mat4 TextureMat;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ModelOffset;

out vec2 texCoord0;

void main() {
    vec3 pos = Position + ModelOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
}
