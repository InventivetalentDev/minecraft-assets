#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D OverlaySampler;

uniform vec2 InSize;

in vec2 texCoord;

uniform float MosaicSize;
uniform vec3 RedMatrix;
uniform vec3 GreenMatrix;
uniform vec3 BlueMatrix;

out vec4 fragColor;

void main(){
    vec2 mosaicInSize = InSize / MosaicSize;
    vec2 fractPix = fract(texCoord * mosaicInSize) / mosaicInSize;

    vec4 baseTexel = texture(DiffuseSampler, texCoord - fractPix);
    float red = dot(baseTexel.rgb, RedMatrix);
    float green = dot(baseTexel.rgb, GreenMatrix);
    float blue = dot(baseTexel.rgb, BlueMatrix);

    vec4 overlayTexel = texture(OverlaySampler, vec2(texCoord.x, 1.0 - texCoord.y));
    overlayTexel.a = 1.0;
    fragColor = mix(vec4(red, green, blue, 1.0), overlayTexel, overlayTexel.a);
}
