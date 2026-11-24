#ifndef MINECRAFT_MATRIX_GLSL
#define MINECRAFT_MATRIX_GLSL

mat2 mat2_rotate_z(float radians) {
    return mat2(
        cos(radians), -sin(radians),
        sin(radians), cos(radians)
    );
}

#endif
