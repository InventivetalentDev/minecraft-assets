#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float vertexDistance;

out vec4 fragColor;

void main() {
#ifdef FOG_IS_SKY
    float fogStart = 0.0;
    float fogEnd = FogSkyEnd;
#else
    float fogStart = FogStart;
    float fogEnd = FogEnd;
#endif
    fragColor = linear_fog(ColorModulator, vertexDistance, fogStart, fogEnd, FogColor);
}
