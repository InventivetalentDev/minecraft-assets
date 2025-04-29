#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float vertexDistance;

out vec4 fragColor;

void main() {
    fragColor = linear_fog(ColorModulator, vertexDistance, 0.0, FogSkyEnd, FogColor);
}
