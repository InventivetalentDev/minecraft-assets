#version 150

uniform sampler2D InSampler;

in vec2 texCoord;
in vec2 oneTexel;
uniform vec2 InSize;

uniform vec3 RedMatrix;
uniform vec3 GreenMatrix;
uniform vec3 BlueMatrix;

const vec3 Gray = vec3(0.3, 0.59, 0.11);
const float Saturation = 1.8;

out vec4 fragColor;

void main() {
    vec4 InTexel = texture(InSampler, texCoord);

    // Color Matrix
    float RedValue = dot(InTexel.rgb, RedMatrix);
    float GreenValue = dot(InTexel.rgb, GreenMatrix);
    float BlueValue = dot(InTexel.rgb, BlueMatrix);
    vec3 OutColor = vec3(RedValue, GreenValue, BlueValue);

    // Saturation
    float Luma = dot(OutColor, Gray);
    vec3 Chroma = OutColor - Luma;
    OutColor = (Chroma * Saturation) + Luma;

    fragColor = vec4(OutColor, 1.0);
}
