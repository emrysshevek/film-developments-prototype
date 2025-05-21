shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform float tilt: hint_range(0.0, 1.0, .1) = 0.0;
uniform float tilt_axis: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float tilt_strength: hint_range(0.1, 5.0, 0.01) = 1.0;

uniform float wave_pos = 0.0;

vec2 uv_normalized_to_proportional(vec2 uv, vec2 view){
	uv = uv * 2.0 - 1.0;
	uv.x *= view.x / view.y;
	return uv;
}

vec2 uv_proportional_to_normalized(vec2 uv, vec2 view){
	uv.x *= view.y / view.x;
	uv = (uv + 1.0) / 2.0;
	return uv;
}

void fragment() {
	if (abs(SCREEN_UV.y - tilt_axis) <= .001) {
		COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	}
	else {
		vec2 uv = uv_normalized_to_proportional(SCREEN_UV, SCREEN_PIXEL_SIZE);
		float offset = clamp(SCREEN_UV.y - tilt_axis, -1.0, 1.0);
		uv.x /= 1.0 + offset * tilt * tilt_strength;
		uv.y /= 1.0 + sign(offset) * tilt * tilt_strength * .078;
		uv = uv_proportional_to_normalized(uv, SCREEN_PIXEL_SIZE);
		COLOR = texture(screen_texture, uv);
	}
	
}
