shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_texture;
uniform float frame_time = .35;

void fragment() {
	float rounded_time = fract(round(TIME / frame_time) * frame_time);
	vec2 noise = texture(noise_texture, clamp(SCREEN_UV + rounded_time, 0.0, 1.0)).xy / 300.0;
	vec2 uv = SCREEN_UV + noise;
	COLOR = texture(screen_texture, uv);
}