#ifndef MINECRAFT_CHUNKSECTION_GLSL
#define MINECRAFT_CHUNKSECTION_GLSL

layout(std140) uniform ChunkSection {
    ivec3 ChunkPosition;
    float ChunkVisibility;
};

#endif
