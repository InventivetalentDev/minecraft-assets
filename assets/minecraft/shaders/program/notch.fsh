#version 120

uniform sampler2D DiffuseSampler;
uniform sampler2D DitherSampler;

varying vec2 texCoord;

uniform vec2 InSize;

void main() {
    vec2 halfSize = InSize * 0.5;
    
    vec2 steppedCoord = texCoord;
    steppedCoord.x = float(int(steppedCoord.x*halfSize.x)) / halfSize.x;
    steppedCoord.y = float(int(steppedCoord.y*halfSize.y)) / halfSize.y;
    
    vec4 noise = texture2D(DitherSampler, steppedCoord * halfSize / 4.0);
    vec4 col = texture2D(DiffuseSampler, steppedCoord) + noise * vec4(1.0/12.0, 1.0/12.0, 1.0/6.0, 1.0);
    float r = float(int(col.r*8.0))/8.0;
    float g = float(int(col.g*8.0))/8.0;
    float b = float(int(col.b*4.0))/4.0;
    gl_FragColor = vec4(r, g, b, col.a);
}
