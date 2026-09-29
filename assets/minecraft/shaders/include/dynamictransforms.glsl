#ifndef MINECRAFT_DYNAMIC_TRANSFORMS_GLSL
#define MINECRAFT_DYNAMIC_TRANSFORMS_GLSL

layout(std140) uniform DynamicTransforms {
    mat4 ModelViewMat;
    mat4 TextureMat;
    vec4 ColorModulator;
    vec3 ModelOffset;
};

#endif
