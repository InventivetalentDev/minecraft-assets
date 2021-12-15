#version 150

uniform sampler2D DiffuseSampler;

in vec2 texCoord;
in vec2 oneTexel;

uniform float LumaRamp;

out vec4 fragColor;

void main(){
    vec4 center = texture(DiffuseSampler, texCoord);
    vec4 up     = texture(DiffuseSampler, texCoord + vec2(        0.0, -oneTexel.y));
    vec4 up2    = texture(DiffuseSampler, texCoord + vec2(        0.0, -oneTexel.y) * 2.0);
    vec4 down   = texture(DiffuseSampler, texCoord + vec2( oneTexel.x,         0.0));
    vec4 down2  = texture(DiffuseSampler, texCoord + vec2( oneTexel.x,         0.0) * 2.0);
    vec4 left   = texture(DiffuseSampler, texCoord + vec2(-oneTexel.x,         0.0));
    vec4 left2  = texture(DiffuseSampler, texCoord + vec2(-oneTexel.x,         0.0) * 2.0);
    vec4 right  = texture(DiffuseSampler, texCoord + vec2(        0.0,  oneTexel.y));
    vec4 right2 = texture(DiffuseSampler, texCoord + vec2(        0.0,  oneTexel.y) * 2.0);
    vec4 ul     = texture(DiffuseSampler, texCoord + vec2(-oneTexel.x, -oneTexel.y));
    vec4 ur     = texture(DiffuseSampler, texCoord + vec2( oneTexel.x, -oneTexel.y));
    vec4 bl     = texture(DiffuseSampler, texCoord + vec2(-oneTexel.x,  oneTexel.y));
    vec4 br     = texture(DiffuseSampler, texCoord + vec2( oneTexel.x,  oneTexel.y));
    vec4 gray = vec4(0.3, 0.59, 0.11, 0.0);
    float uDiff = dot(abs(center - up), gray);
    float dDiff = dot(abs(center - down), gray);
    float lDiff = dot(abs(center - left), gray);
    float rDiff = dot(abs(center - right), gray);
    float u2Diff = dot(abs(center - up2), gray);
    float d2Diff = dot(abs(center - down2), gray);
    float l2Diff = dot(abs(center - left2), gray);
    float r2Diff = dot(abs(center - right2), gray);
    float ulDiff = dot(abs(center - ul), gray);
    float urDiff = dot(abs(center - ur), gray);
    float blDiff = dot(abs(center - bl), gray);
    float brDiff = dot(abs(center - br), gray);
    float sum = uDiff + dDiff + lDiff + rDiff + u2Diff + d2Diff + l2Diff + r2Diff + ulDiff + urDiff + blDiff + brDiff;
    float sumLuma = clamp(sum, 0.0, 1.0);

    fragColor = vec4(sumLuma, sumLuma, sumLuma, 1.0);
}
