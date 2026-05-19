#version 330

layout(std140) uniform SpriteAnimationInfo {
    mat4 ProjectionMatrix;
    mat4 SpriteMatrix;
    float UPadding;
    float VPadding;
    int MipMapLevel;
};
