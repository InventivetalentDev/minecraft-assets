#version 150

#moj_import <minecraft:fog.glsl>


in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    color.a *= linear_fog_fade(vertexDistance, 0, FogCloudsEnd);
    fragColor = color;
}
