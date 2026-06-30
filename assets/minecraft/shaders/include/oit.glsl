#ifdef OIT
    #moj_import <minecraft:oit_common.glsl>

    #if defined(OIT_TRANSMITTANCE) || defined(OIT_ACCUMULATE)
        #moj_import <minecraft:oit_depth_sample.glsl>
    #endif

    #if defined(OIT_DEPTH_BOUNDS)
        #moj_import <minecraft:oit_depth_bounds.glsl>
    #elif defined(OIT_TRANSMITTANCE)
        #moj_import <minecraft:oit_add_transmittance.glsl>
    #else
        #moj_import <minecraft:oit_sample.glsl>
    #endif
#endif

void handleOpaquePartDiscards(float alpha) {
    #ifdef OIT
    if (alpha > OIT_OPAQUE_PARTS_THRESHOLD) {
        discard;
    }
    #elif defined(OIT_OPAQUE_PARTS_THRESHOLD)
    if (alpha <= OIT_OPAQUE_PARTS_THRESHOLD) {
        discard;
    }
    #endif
}

void executeAlphaOnlyPhase(float deviceDepth, float alpha) {
    #ifdef OIT_ADDITIVE
    // Additive surfaces do not occlude, so they contribute nothing to the depth bounds or
    // the transmittance function. Discard to avoid writing to those targets.
    discard;
    #elif defined(OIT_DEPTH_BOUNDS)
    if (alpha < 0.01) {
        discard;
    }
    calculateDepthBounds(deviceDepth);
    #elif defined(OIT_TRANSMITTANCE)
    addTransmittance(alpha);
    #endif
}
