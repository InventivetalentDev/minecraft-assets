#version 120

uniform sampler2D DiffuseSampler;
uniform sampler2D PrevSampler;

varying vec2 texCoord;
varying vec2 oneTexel;

uniform vec2 InSize;

uniform vec3 Phosphor = vec3(0.7, 0.7, 0.7);
uniform float LerpFactor = 1.0;

void main() {
    vec3 CurrTexel = texture2D(DiffuseSampler, texCoord).rgb;
    vec3 PrevTexel = texture2D(PrevSampler, texCoord).rgb;
    
    gl_FragColor = vec4(max(PrevTexel * Phosphor, CurrTexel), 1.0);
}
