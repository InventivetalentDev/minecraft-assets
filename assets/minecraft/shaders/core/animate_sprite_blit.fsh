#version 330

#moj_import <minecraft:animation_sprite.glsl>

uniform sampler2D Sprite;

in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = textureLod(Sprite, texCoord0, MipMapLevel);
    fragColor = color;
}
