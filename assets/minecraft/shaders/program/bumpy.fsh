#version 150

uniform sampler2D DiffuseSampler;

in vec2 texCoord;
in vec2 oneTexel;

out vec4 fragColor;

void main(){
    vec4 c = texture(DiffuseSampler, texCoord);
    vec4 u = texture(DiffuseSampler, texCoord + vec2(        0.0, -oneTexel.y));
    vec4 d = texture(DiffuseSampler, texCoord + vec2(        0.0,  oneTexel.y));
    vec4 l = texture(DiffuseSampler, texCoord + vec2(-oneTexel.x,         0.0));
    vec4 r = texture(DiffuseSampler, texCoord + vec2( oneTexel.x,         0.0));

    vec4 nc = normalize(c);
    vec4 nu = normalize(u);
    vec4 nd = normalize(d);
    vec4 nl = normalize(l);
    vec4 nr = normalize(r);

    float du = dot(nc, nu);
    float dd = dot(nc, nd);
    float dl = dot(nc, nl);
    float dr = dot(nc, nr);

    float i = 64.0;

    float f = 1.0;
    f += (du * i) - (dd * i);
    f += (dr * i) - (dl * i);

    vec4 color = c * clamp(f, 0.5, 2.0);
    fragColor = vec4(color.rgb, 1.0);
}
