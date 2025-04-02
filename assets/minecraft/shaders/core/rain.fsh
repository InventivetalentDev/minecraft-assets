#version 150

uniform sampler2D Sampler0;
uniform float GameTime;

in vec2 texCoord0;

out vec4 fragColor;

uniform vec4 ColorModulator;

float random (float v) {
    return fract(sin(v) * 43758.5453123);
}

void main() {
    const float columns = 80.0;
    const float rows = 240.0;

    vec2 uv = texCoord0;

    float column = floor(uv.x * columns);
    float row = floor(uv.y * rows);

    float runners = (1.0 + 3.0 * random(column));
    float runner_phase = random(3.6 * column + 0.4231) * 2.0 + (GameTime * 300.0);

    float cells_per_runner = floor(rows / runners);
    float runner = floor(row / cells_per_runner);

    float runner_start = cells_per_runner * runner - runner_phase;
    float cell_to_runner_start = row - runner_start;

    float brightness = 1.0 - fract(cell_to_runner_start / cells_per_runner);
    float middleness = (1.0 - 2.0 * abs(uv.y - 0.5));
    float green = pow(brightness, 32.0) * middleness;
    float not_green = pow(brightness, 128.0) * middleness;

    vec4 glow = vec4(not_green, green, not_green, 1.0);

    const float glyph_width = 128.0 / 8.0;
    const float glyph_height = 128.0 / 8.0;

    float glyph_row = floor(random(3 * column + 5 * row) * 8.0);
    float glyph_column = floor(random(7 * column + 9 * row) * 17.0);

    float shift_x = fract(uv.x * columns);
    float shift_y = 1.0 - fract(uv.y * rows);
    vec4 glyph_color = texture(Sampler0, vec2((glyph_column + shift_x) / glyph_width, (glyph_row + shift_y) / glyph_height));

    fragColor = glow * glyph_color * ColorModulator;
}
