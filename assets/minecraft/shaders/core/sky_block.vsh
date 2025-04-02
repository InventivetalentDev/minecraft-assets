#version 150

#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform vec3 ModelOffset;
uniform mat4 TextureMat;

out vec4 shimmer;
out vec2 texCoordBlock;
out vec4 texProjSky;
out vec2 texCoordGlint;

void main() {
    vec3 pos = Position + ModelOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    texProjSky = projection_from_position(gl_Position);
    texCoordBlock = UV0;
    texCoordGlint = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;

    shimmer = Color;
}
