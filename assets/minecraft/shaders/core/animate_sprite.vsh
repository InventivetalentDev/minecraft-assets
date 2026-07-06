#version 330

#moj_import <minecraft:animation_sprite.glsl>

out float fAnimationProgress;
out vec2 texCoord0;

const vec2[] positions = vec2[](
    vec2(0, 0),
    vec2(1, 0),
    vec2(0, 1),
    vec2(0, 1),
    vec2(1, 0),
    vec2(1, 1)
);

void main() {
    int index = gl_VertexID & 7;
    float frameProgress = (gl_VertexID >> 3) / 1000.0;
    vec2 padding = vec2(UPadding, VPadding);
    gl_Position = ProjectionMatrix * SpriteMatrix * vec4(positions[index], 0, 1);
    vec2 uv = positions[index];
    vec2 direction = uv * 2.0 - 1.0;
    texCoord0 = uv + (padding * direction);
    fAnimationProgress = frameProgress;
}
