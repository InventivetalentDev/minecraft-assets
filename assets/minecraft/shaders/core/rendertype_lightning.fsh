#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    fragColor = vertexColor * ColorModulator * linear_fog_fade(vertexDistance, FogStart, FogEnd);
}
