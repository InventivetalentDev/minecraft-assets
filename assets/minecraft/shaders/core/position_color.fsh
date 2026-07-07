#version 330

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:oit.glsl>

in vec4 vertexColor;

#ifndef OIT_ALPHA_ONLY
out vec4 fragColor;
#endif

vec4 calculateFinalColor(vec4 color) {
    #ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color);
    #endif
    return color;
}

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }

    color *= ColorModulator;

    #ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
    #else
    fragColor = calculateFinalColor(color);
    #endif
}
