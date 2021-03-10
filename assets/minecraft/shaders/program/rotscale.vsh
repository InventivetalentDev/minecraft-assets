#version 120

attribute vec4 Position;

uniform mat4 ProjMat;
uniform vec2 InSize;
uniform vec2 OutSize;

uniform vec2 InScale;
uniform vec2 InOffset;
uniform float InRotation;
uniform float Time;

varying vec2 texCoord;
varying vec2 scaledCoord;

void main(){
    vec4 outPos = ProjMat * vec4(Position.xy, 0.0, 1.0);
    gl_Position = vec4(outPos.xy, 0.2, 1.0);

    texCoord = Position.xy / OutSize;

    float Deg2Rad = 0.0174532925;
    float InRadians = InRotation * Deg2Rad;
    float Cosine = cos(InRadians);
    float Sine = sin(InRadians);
    float RotU = texCoord.x * Cosine - texCoord.y * Sine;
    float RotV = texCoord.y * Cosine + texCoord.x * Sine;
    scaledCoord = vec2(RotU, RotV) * InScale + InOffset;
}
