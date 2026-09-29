#ifndef MINECRAFT_TERRAINGLOBLAS_GLSL
#define MINECRAFT_TERRAINGLOBALS_GLSL

layout(std140) uniform TerrainUniform {
    mat4 ModelViewMat;
    ivec2 TextureSize;
};

#endif
