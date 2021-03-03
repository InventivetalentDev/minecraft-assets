#version 110

uniform sampler2D DiffuseSampler;
uniform sampler2D PrevSampler;

varying vec2 texCoord;
varying vec2 oneTexel;

uniform vec2 InSize;

uniform vec3 Phosphor;

void main() {
    vec4 CurrTexel = texture2D(DiffuseSampler, texCoord);
    vec4 PrevTexel = texture2D(PrevSampler, texCoord);

    gl_FragColor = vec4(max(PrevTexel.rgb * Phosphor, CurrTexel.rgb), 1.0);
}
