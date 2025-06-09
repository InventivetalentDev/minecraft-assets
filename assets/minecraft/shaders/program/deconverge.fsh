#version 150

uniform sampler2D DiffuseSampler;

in vec2 texCoord;
in vec2 oneTexel;

uniform vec2 InSize;

uniform vec3 ConvergeX;
uniform vec3 ConvergeY;
uniform vec3 RadialConvergeX;
uniform vec3 RadialConvergeY;

out vec4 fragColor;

void main() {
    vec3 CoordX = texCoord.x * RadialConvergeX;
    vec3 CoordY = texCoord.y * RadialConvergeY;

    CoordX += ConvergeX * oneTexel.x - (RadialConvergeX - 1.0) * 0.5;
    CoordY += ConvergeY * oneTexel.y - (RadialConvergeY - 1.0) * 0.5;

    float RedValue   = texture(DiffuseSampler, vec2(CoordX.x, CoordY.x)).r;
    float GreenValue = texture(DiffuseSampler, vec2(CoordX.y, CoordY.y)).g;
    float BlueValue  = texture(DiffuseSampler, vec2(CoordX.z, CoordY.z)).b;
    float AlphaValue  = texture(DiffuseSampler, texCoord).a;

    fragColor = vec4(RedValue, GreenValue, BlueValue, 1.0);
}
