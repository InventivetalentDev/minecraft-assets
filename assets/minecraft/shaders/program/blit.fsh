#version 120

uniform sampler2D DiffuseSampler;

uniform vec4 ColorModulate;

varying vec2 texCoord;

void main(){
    vec4 outColor = texture2D(DiffuseSampler, texCoord) * ColorModulate;
    gl_FragColor = vec4(outColor.rgb, 1.0);
}
