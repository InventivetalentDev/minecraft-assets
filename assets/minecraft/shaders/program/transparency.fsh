#version 110

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;
uniform sampler2D TranslucentSampler;
uniform sampler2D TranslucentDepthSampler;
uniform sampler2D ItemEntitySampler;
uniform sampler2D ItemEntityDepthSampler;
uniform sampler2D ParticlesSampler;
uniform sampler2D ParticlesDepthSampler;
uniform sampler2D WeatherSampler;
uniform sampler2D WeatherDepthSampler;
uniform sampler2D CloudsSampler;
uniform sampler2D CloudsDepthSampler;

varying vec2 texCoord;

#define NUM_LAYERS 6

vec4 color_layers[NUM_LAYERS];
float depth_layers[NUM_LAYERS];
int active_layers = 0;

void try_insert( vec4 color, float depth ) {
    if ( color.a == 0.0 ) {
        return;
    }

    color_layers[active_layers] = color;
    depth_layers[active_layers] = depth;

    int jj = active_layers++;
    int ii = jj - 1;
    while ( jj > 0 && depth_layers[jj] > depth_layers[ii] ) {
        float depthTemp = depth_layers[ii];
        depth_layers[ii] = depth_layers[jj];
        depth_layers[jj] = depthTemp;

        vec4 colorTemp = color_layers[ii];
        color_layers[ii] = color_layers[jj];
        color_layers[jj] = colorTemp;

        jj = ii--;
    }
}

vec3 blend( vec3 dst, vec4 src ) {
    return ( dst * ( 1.0 - src.a ) ) + src.rgb;
}

void main() {
    color_layers[0] = vec4( texture2D( DiffuseSampler, texCoord ).rgb, 1.0 );
    depth_layers[0] = texture2D( DiffuseDepthSampler, texCoord ).r;
    active_layers = 1;

    try_insert( texture2D( TranslucentSampler, texCoord ), texture2D( TranslucentDepthSampler, texCoord ).r );
    try_insert( texture2D( ItemEntitySampler, texCoord ), texture2D( ItemEntityDepthSampler, texCoord ).r );
    try_insert( texture2D( ParticlesSampler, texCoord ), texture2D( ParticlesDepthSampler, texCoord ).r );
    try_insert( texture2D( WeatherSampler, texCoord ), texture2D( WeatherDepthSampler, texCoord ).r );
    try_insert( texture2D( CloudsSampler, texCoord ), texture2D( CloudsDepthSampler, texCoord ).r );

    vec3 texelAccum = color_layers[0].rgb;
    for ( int ii = 1; ii < active_layers; ++ii ) {
        texelAccum = blend( texelAccum, color_layers[ii] );
    }

    gl_FragColor = vec4( texelAccum.rgb, 1.0 );
}
