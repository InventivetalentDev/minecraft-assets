#version 150

in vec4 Position;

uniform mat4 ProjMat;
uniform vec2 OutSize;

uniform float SubPixelShift;

out vec2 texCoord;
out vec4 posPos;

void main() {
    vec4 outPos = ProjMat * vec4(Position.xy, 0.0, 1.0);
    gl_Position = vec4(outPos.xy, 0.2, 1.0);

    texCoord = Position.xy / OutSize;
    posPos.xy = texCoord.xy;
    posPos.zw = texCoord.xy - (1.0/OutSize * vec2(0.5 + SubPixelShift));
}
