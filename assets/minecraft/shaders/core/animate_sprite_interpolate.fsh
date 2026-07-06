#version 330

#moj_import <minecraft:animation_sprite.glsl>

uniform sampler2D CurrentSprite;
uniform sampler2D NextSprite;

in float fAnimationProgress;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 currentColor = textureLod(CurrentSprite, texCoord0, MipMapLevel);
    vec4 nextColor = textureLod(NextSprite, texCoord0, MipMapLevel);
    fragColor = mix(currentColor, nextColor, fAnimationProgress);
}
