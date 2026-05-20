#version 330

in vec2 texcoord;             // texture coordinate of the fragment
uniform sampler2D tex;        // texture of the window

ivec2 window_size = textureSize(tex, 0); // Size of the window
ivec2 window_center = ivec2(window_size.x/2, window_size.y/2);

// Default window post-processing:
vec4 default_post_processing(vec4 c);

float max_opacity = 1.0; 
float opacity_threshold(float opacity)
{
  if (opacity >= max_opacity) {
    return 1.0;
  } else {
    return min(1.0, opacity/max_opacity);
  }
}

// --- Optimized Noise Functions ---

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// OPTIMIZATION 1: Reduced from 6 octaves to 3. 
// This is the biggest performance saver.
float fbm(vec2 p) {
    float v = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 3; i++) {
        v += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return v;
}

// OPTIMIZATION 2: Reduced the nesting depth of the warps.
float warpedFbm(vec2 p, float t) {
    vec2 q = vec2(fbm(p + vec2(0.0, 0.0)),
                  fbm(p + vec2(5.2, 1.3)));

    vec2 r = vec2(fbm(p + 4.0 * q + vec2(1.7, 9.2) + 0.3 * t),
                  fbm(p + 4.0 * q + vec2(8.3, 2.8) + 0.25 * t));

    return fbm(p + 4.0 * r);
}

// --- Main Animation Function ---
vec4 anim(float time) {
    float p = time; 
    
    vec2 uv = texcoord / vec2(window_size);
    
    // Fake seed
    float seed = hash(vec2(window_size)) * 100.0;
    float t = p * 12.0 + seed;

    float fluid = warpedFbm(uv * 2.0 + seed, t);

    vec2 center = uv - 0.5;
    float dist = length(center * vec2(1.0, 0.7));

    float appear = (1.0 - dist * 1.2) + (1.0 - fluid) * 0.7;
    float reveal = smoothstep(appear + 0.5, appear - 0.5, (1.0 - p) * 1.8);

    float distort_strength = (1.0 - p) * (1.0 - p) * 0.35;
    
    // OPTIMIZATION 3: Using standard noise() instead of fbm() for the UV distortion.
    // It's just squishing the texture, it doesn't need 3 layers of fractal detail.
    vec2 wq = vec2(noise(uv * 4.0 + vec2(0.0, t * 0.2)),
                   noise(uv * 4.0 + vec2(5.2, t * 0.2)));
    vec2 wr = vec2(noise(uv * 4.0 + 4.0 * wq + vec2(1.7, 9.2)),
                   noise(uv * 4.0 + 4.0 * wq + vec2(8.3, 2.8)));
    
    vec2 warped_uv = uv + (wr - 0.5) * distort_strength;

    ivec2 warped_pixel = ivec2(warped_uv * vec2(window_size));

    if (warped_pixel.x < 0 || warped_pixel.x >= window_size.x ||
        warped_pixel.y < 0 || warped_pixel.y >= window_size.y) {
        return vec4(0.0);
    }

    vec4 color = texelFetch(tex, warped_pixel, 0);
    color *= reveal;

    return color;
}

// Default window shader:
vec4 window_shader() {
  vec4 c = texelFetch(tex, ivec2(texcoord), 0);
  c = default_post_processing(c);
  
  float opacity = opacity_threshold(c.w);
  if (opacity == 0.0) {
    return c;
  }
  
  vec4 anim_c = anim(opacity);
  return default_post_processing(anim_c);
}
