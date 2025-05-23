shader_type canvas_item;

//uniform sampler2D screen_texture: hint_screen_texture;

uniform float fade: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float strength: hint_range(0.0, 5.0, 0.1) = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 original = texture(TEXTURE, UV);
	vec4 base = vec4(1.0, 1.0, 1.0, 1.0);
	float bw_val = (original.r + original.g + original.b) / 3.0;
	
	float mix_val = fade / bw_val;
	COLOR = mix(base, original, clamp(mix_val, 0, strength));
}
