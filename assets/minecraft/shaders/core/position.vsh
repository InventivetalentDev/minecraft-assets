#version 150

#moj_import <fog.glsl>

in vec3 Position;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out float vertexDistance;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = cylindrical_distance(ModelViewMat, Position);
}
