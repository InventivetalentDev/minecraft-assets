#version 330

#moj_import <minecraft:oit.glsl>

uniform sampler2D Sampler0;

in vec2 texCoord;

out vec4 fragColor;

void main() {
    vec4 accumulatedColor = texelFetch(Sampler0, ivec2(gl_FragCoord.xy), 0);

    float sampledTransmittance = sampleTransmittance(ivec2(gl_FragCoord.xy), 100000.0f, 0);
    float coverage = 1.0 - sampledTransmittance;

    // Additive surfaces contribute colour but no coverage, so they only show up in rgb.
    // Discard pixels that have neither coverage nor additive light.
    if (coverage < 0.00001 && dot(accumulatedColor.rgb, vec3(1.0)) < 0.00001) {
        discard;
    }

    // Additive-only pixels have accumulatedColor.a ~ 0 (no coverage), so we skip the renormalization and let their
    // premultiplied light pass through untouched.
    float normalization = accumulatedColor.a > 0.00001 ? coverage / accumulatedColor.a : 1.0;
    fragColor = vec4(accumulatedColor.rgb * normalization, coverage);
}
