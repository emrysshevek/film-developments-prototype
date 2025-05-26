shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform vec4 light_color: source_color;

void fragment() {
	vec4 original = texture(screen_texture, SCREEN_UV);
	COLOR = original;
	COLOR.r = mix(0.0, light_color.r, original.r);
	COLOR.g = mix(0.0, light_color.g, original.g);
	COLOR.b = mix(0.0, light_color.b, original.b);
}

