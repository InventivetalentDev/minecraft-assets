#ifdef OIT
    #include <minecraft:oit_common.glsl>

    #if defined(OIT_TRANSMITTANCE) || defined(OIT_ACCUMULATE)
        #include <minecraft:oit_depth_sample.glsl>
    #endif

    #if defined(OIT_DEPTH_BOUNDS)
        #include <minecraft:oit_depth_bounds.glsl>
    #elif defined(OIT_TRANSMITTANCE)
        #include <minecraft:oit_add_transmittance.glsl>
    #else
        #include <minecraft:oit_sample.glsl>
    #endif
#endif

void executeAlphaOnlyPhase(float deviceDepth, float alpha) {
    #ifdef OIT_ADDITIVE
    // Additive surfaces do not occlude, so they contribute nothing to the depth bounds or
    // the transmittance function. Discard to avoid writing to those targets.
    discard;
    #elif defined(OIT_DEPTH_BOUNDS)
    if (alpha < 0.01) {
        discard;
    }
    calculateDepthBounds(deviceDepth, alpha);
    #elif defined(OIT_TRANSMITTANCE)
    addTransmittance(1.0 - alpha);
    #endif
}
