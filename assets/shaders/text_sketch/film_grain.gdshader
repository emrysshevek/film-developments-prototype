shader_type canvas_item;

// Uniforms
uniform sampler2D screen_texture : hint_screen_texture;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain

uniform float frame_time = .35;

void fragment() {
	float rounded_time = round(TIME / frame_time) * frame_time;
	
    // Sample the original screen texture
    vec4 original_color = texture(screen_texture, SCREEN_UV);
	float bw_val = (original_color.r + original_color.g + original_color.b) / 3.0;
	vec4 bw = vec4(bw_val, bw_val, bw_val, original_color.a);
	float intensity = 1.0 - abs(bw_val * 2.0 - 1.0);

    // Generate random noise
    float noise = (fract(sin(dot(UV, vec2(12.9898 + rounded_time, 78.233 + rounded_time))) * 43758.5453));

    // Add noise to the original color
    bw.rgb += noise * grain_amount * intensity;
	
    // Clamp the final color to make sure it stays in the valid range
    COLOR = clamp(bw, 0.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
