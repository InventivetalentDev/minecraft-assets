#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ModelViewProjMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec4 normal;

void main() {
    gl_Position = ModelViewProjMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    vertexColor = Color;
    normal = ModelViewProjMat * vec4(Normal, 0.0);
}
