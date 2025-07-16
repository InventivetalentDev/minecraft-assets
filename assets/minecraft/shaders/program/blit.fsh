#version 120

uniform sampler2D DiffuseSampler;

varying vec2 texCoord;

void main(){
    gl_FragColor = vec4(texture2D(DiffuseSampler, texCoord).rgb, 1.0);
}
