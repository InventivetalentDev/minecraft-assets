#version 150

#moj_import <minecraft:projection.glsl>

in vec4 Position;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform RotScaleConfig {
    vec2 InScale;
    vec2 InOffset;
    float InRotation;
};

out vec2 texCoord;
out vec2 scaledCoord;

void main(){
    vec4 outPos = ProjMat * vec4(Position.xy * OutSize, 0.0, 1.0);
    gl_Position = vec4(outPos.xy, 0.2, 1.0);

    texCoord = Position.xy;

    float Deg2Rad = 0.0174532925;
    float InRadians = InRotation * Deg2Rad;
    float Cosine = cos(InRadians);
    float Sine = sin(InRadians);
    float RotU = texCoord.x * Cosine - texCoord.y * Sine;
    float RotV = texCoord.y * Cosine + texCoord.x * Sine;
    scaledCoord = vec2(RotU, RotV) * InScale + InOffset;
}
