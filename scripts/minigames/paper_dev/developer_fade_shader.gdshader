shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform float fade: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float developer_strength: hint_range(1.0, 10.0, 0.10) = 4.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

float easing(float x, float strength) {
	return 1.0 - pow(1.0 - x, strength);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 original = texture(screen_texture, SCREEN_UV);
	vec4 base = vec4(1.0, 1.0, 1.0, 1.0);
	
	float mix_val = fade / original.r;
	COLOR = mix(base, original, clamp(mix_val, 0.0, 1.0));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
