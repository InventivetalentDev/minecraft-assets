#ifndef MINECRAFT_SAMPLE_LIGHTMAP_GLSL
#define MINECRAFT_SAMPLE_LIGHTMAP_GLSL

// This is used for lightmap stored in terrain vertex format which is in RG8_UNORM
vec4 sample_lightmap(sampler2D lightMap, vec2 uv) {
    return texture(lightMap, clamp(uv + 0.5 / 16.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}

// This is used for lightmap stored anything other than terrain, which is in RG16_SINT
vec4 sample_lightmap(sampler2D lightMap, ivec2 uv) {
    return sample_lightmap(lightMap, (uv / 255.0));
}

#endif
