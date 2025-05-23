shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform float focus = 0.0;
uniform float min_lod = 0.5;

void fragment() {
	float lod = max(abs(focus), min_lod);
	vec4 original = texture(screen_texture, SCREEN_UV, lod);
	vec4 offset = texture(screen_texture, SCREEN_UV * (1.0 + focus / 70.0), lod);
	COLOR = mix(original, offset, clamp(focus, 0.0, 1.0)) - .01;
}