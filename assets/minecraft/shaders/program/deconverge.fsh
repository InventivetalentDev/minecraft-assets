#version 110

uniform sampler2D DiffuseSampler;

varying vec2 texCoord;
varying vec2 oneTexel;

uniform vec2 InSize;

uniform vec3 ConvergeX;
uniform vec3 ConvergeY;
uniform vec3 RadialConvergeX;
uniform vec3 RadialConvergeY;

void main() {
    vec3 CoordX = texCoord.x * RadialConvergeX;
    vec3 CoordY = texCoord.y * RadialConvergeY;

    CoordX += ConvergeX * oneTexel.x - (RadialConvergeX - 1.0) * 0.5;
    CoordY += ConvergeY * oneTexel.y - (RadialConvergeY - 1.0) * 0.5;

    float RedValue   = texture2D(DiffuseSampler, vec2(CoordX.x, CoordY.x)).r;
    float GreenValue = texture2D(DiffuseSampler, vec2(CoordX.y, CoordY.y)).g;
    float BlueValue  = texture2D(DiffuseSampler, vec2(CoordX.z, CoordY.z)).b;
    float AlphaValue  = texture2D(DiffuseSampler, texCoord).a;

    gl_FragColor = vec4(RedValue, GreenValue, BlueValue, 1.0);
}
