#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;

out float vertexDistance;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

#ifdef FOG_IS_SKY
    vertexDistance = fog_distance(Position, FOG_SHAPE_CYLINDER);
#else
    vertexDistance = fog_distance(Position, FogShape);
#endif
}
