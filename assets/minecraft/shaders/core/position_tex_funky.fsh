#version 150

uniform sampler2D Sampler0;

uniform float WallTime;

in vec2 texCoord0;

out vec4 fragColor;

void main() {
    float a = texture(Sampler0, texCoord0).a;

    if (a < 0.1) {
        discard;
    }

    float p = a * 3.14159265 * 2;
    float t = WallTime / 1000.0 * 4.0;

    float r = 0.5 * abs(sin((t + p) * 1.0 / 3.0)) + 0.5 * abs(sin((t + p / 2.0) * 1.0 / 17.0));
    float g = 0.5 * abs(sin((t + p) * 1.0 / 5.0)) + 0.5 * abs(sin((t + p / 2.0) * 1.0 / 13.0));
    float b = 0.5 * abs(sin((t + p) * 1.0 / 7.0)) + 0.5 * abs(sin((t + p / 2.0) * 1.0 / 11.0));

    fragColor = vec4(r, g, b, a);
}
