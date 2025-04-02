#version 150

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

in vec4 shimmer;
in vec2 texCoordBlock;
in vec4 texProjSky;
in vec2 texCoordGlint;

out vec4 fragColor;

void main() {
    vec4 textureColor = texture(Sampler0, texCoordBlock);
    vec4 skyColor = textureProj(Sampler1, texProjSky);
    vec4 glintColor = texture(Sampler2, texCoordGlint) * shimmer;

    fragColor = mix(skyColor, textureColor, glintColor * textureColor.a);
}
