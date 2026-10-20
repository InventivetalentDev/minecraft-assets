vec2 fullscreen_triangle_position() {
    return vec2((gl_VertexIndex << 1) & 2, gl_VertexIndex & 2) * 2.0 - 1.0;
}
