#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:oit.glsl>

uniform sampler2D Sampler0;
uniform sampler2D DepthBoundsSampler;

layout(location = 0) in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

void main() {
    ivec2 pixelCoords = ivec2(gl_FragCoord.xy);
    vec4 accumulatedColor = texelFetch(Sampler0, pixelCoords, 0);

    float sampledTransmittance = sampleTransmittance(pixelCoords, 100000.0f, 1.0);
    float coverage = 1.0 - (sampledTransmittance < OIT_FULLY_OPAQUE_TOTAL_TRANSMITTANCE ? 0.0 : sampledTransmittance);

    // Additive surfaces contribute colour but no coverage, so they only show up in rgb.
    // Discard pixels that have neither coverage nor additive light.
    if (coverage < 0.00001 && dot(accumulatedColor.rgb, vec3(1.0)) < 0.00001) {
        discard;
    }

    // Additive-only pixels have accumulatedColor.a ~ 0 (no coverage), so we skip the renormalization and let their
    // premultiplied light pass through untouched.
    float normalization = accumulatedColor.a > 0.00001 ? coverage / accumulatedColor.a : 1.0;
    fragColor = vec4(accumulatedColor.rgb * normalization, coverage);

    float closestBoundDeviceDepth = texelFetch(DepthBoundsSampler, pixelCoords, 0).b;
    gl_FragDepth = closestBoundDeviceDepth;
}
