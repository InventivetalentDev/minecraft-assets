#version 110

//#define DEBUG_DEPTH
//#define DEBUG_ALPHA
//#define DEBUG_COLOR

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;
uniform sampler2D TranslucentSampler;
uniform sampler2D TranslucentDepthSampler;
uniform sampler2D ItemEntitySampler;
uniform sampler2D ItemEntityDepthSampler;
uniform sampler2D ParticlesSampler;
uniform sampler2D ParticlesDepthSampler;
uniform sampler2D WeatherSampler;
uniform sampler2D WeatherDepthSampler;
uniform sampler2D CloudsSampler;
uniform sampler2D CloudsDepthSampler;

varying vec2 texCoord;

vec3 blend(vec3 destination, vec4 source) {
    return (destination * (1.0 - source.a)) + source.rgb;
}

#ifdef DEBUG_DEPTH
vec3 debugDepth(vec3 destination, vec2 uv);
#endif
#ifdef DEBUG_ALPHA
vec3 debugAlpha(vec3 destination, vec2 uv);
#endif
#ifdef DEBUG_COLOR
vec3 debugColor(vec3 destination, vec2 uv);
#endif

struct Layer {
    vec4 color;
    float depth;
};

#define NUM_LAYERS 6

Layer layers[NUM_LAYERS];
int layerIndices[NUM_LAYERS];

void init_arrays() {
    layers[0] = Layer(vec4(texture2D(DiffuseSampler, texCoord).rgb, 1.0), texture2D(DiffuseDepthSampler, texCoord).r);
    layers[1] = Layer(texture2D(TranslucentSampler, texCoord), texture2D(TranslucentDepthSampler, texCoord).r);
    layers[2] = Layer(texture2D(ItemEntitySampler, texCoord), texture2D(ItemEntityDepthSampler, texCoord).r);
    layers[3] = Layer(texture2D(ParticlesSampler, texCoord), texture2D(ParticlesDepthSampler, texCoord).r);
    layers[4] = Layer(texture2D(WeatherSampler, texCoord), texture2D(WeatherDepthSampler, texCoord).r);
    layers[5] = Layer(texture2D(CloudsSampler, texCoord), texture2D(CloudsDepthSampler, texCoord).r);

    for (int ii = 0; ii < NUM_LAYERS; ++ii) {
        layerIndices[ii] = ii;
    }

    for (int ii = 0; ii < NUM_LAYERS; ++ii) {
        for (int jj = 0; jj < NUM_LAYERS - ii - 1; ++jj) {
            if (layers[layerIndices[jj]].depth < layers[layerIndices[jj + 1]].depth) {
                int temp = layerIndices[jj];
                layerIndices[jj] = layerIndices[jj + 1];
                layerIndices[jj + 1] = temp;
            }
        }
    }
}

void main() {
    init_arrays();

    vec3 OutTexel = vec3(0.0);

    for (int ii = 0; ii < NUM_LAYERS; ++ii) {
        OutTexel = blend(OutTexel, layers[layerIndices[ii]].color);
    }

#ifdef DEBUG_DEPTH
    OutTexel = debugDepth(OutTexel, texCoord);
#endif
#ifdef DEBUG_ALPHA
    OutTexel = debugAlpha(OutTexel, texCoord);
#endif
#ifdef DEBUG_COLOR
    OutTexel = debugColor(OutTexel, texCoord);
#endif

    gl_FragColor = vec4(OutTexel.rgb, 1.0);
}

#ifdef DEBUG_DEPTH
vec3 debugDepth(vec3 destination, vec2 uv) {
    if (uv.x >= 0.75) {
        uv.x -= 0.75;
        uv.x *= 4.0;
        if (uv.y <= 0.25) {
            uv.y *= 4.0;
            destination = vec3(pow(texture2D(DiffuseDepthSampler, uv).r, 128.0));
        } else if (uv.y >= 0.75) {
            uv.y -= 0.75;
            uv.y *= 4.0;
            destination = vec3(pow(texture2D(TranslucentDepthSampler, uv).r, 128.0));
        }
    } else if (uv.x <= 0.25) {
        uv.x *= 4.0;
        if (uv.y <= 0.25) {
            uv.y *= 4.0;
            destination = vec3(pow(texture2D(ItemEntityDepthSampler, uv).r, 128.0));
        } else if (uv.y >= 0.75) {
            uv.y -= 0.75;
            uv.y *= 4.0;
            destination = vec3(pow(texture2D(ParticlesDepthSampler, uv).r, 128.0));
        }
    }

    return destination;
}
#endif

#ifdef DEBUG_ALPHA
vec3 debugAlpha(vec3 destination, vec2 uv) {
    if (uv.x >= 0.75) {
        uv.x -= 0.75;
        uv.x *= 4.0;
        if (uv.y <= 0.25) {
            uv.y *= 4.0;
            destination = texture2D(DiffuseSampler, uv).aaa;
        } else if (uv.y >= 0.75) {
            uv.y -= 0.75;
            uv.y *= 4.0;
            destination = texture2D(TranslucentSampler, uv).aaa;
        }
    } else if (uv.x <= 0.25) {
        uv.x *= 4.0;
        if (uv.y <= 0.25) {
            uv.y *= 4.0;
            destination = texture2D(ItemEntitySampler, uv).aaa;
        } else if (uv.y >= 0.75) {
            uv.y -= 0.75;
            uv.y *= 4.0;
            destination = texture2D(ParticlesSampler, uv).aaa;
        }
    }

    return destination;
}
#endif

#ifdef DEBUG_COLOR
vec3 debugColor(vec3 destination, vec2 uv) {
    if (uv.x >= 0.75) {
        uv.x -= 0.75;
        uv.x *= 4.0;
        if (uv.y <= 0.25) {
            uv.y *= 4.0;
            destination = texture2D(DiffuseSampler, uv).rgb;
        } else if (uv.y >= 0.75) {
            uv.y -= 0.75;
            uv.y *= 4.0;
            destination = texture2D(TranslucentSampler, uv).rgb;
        }
    } else if (uv.x <= 0.25) {
        uv.x *= 4.0;
        if (uv.y <= 0.25) {
            uv.y *= 4.0;
            destination = texture2D(ItemEntitySampler, uv).rgb;
        } else if (uv.y >= 0.75) {
            uv.y -= 0.75;
            uv.y *= 4.0;
            destination = texture2D(ParticlesSampler, uv).rgb;
        }
    }

    return destination;
}
#endif
