shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

group_uniforms setup;
uniform bool debug = false;
uniform float tilt_axis: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec2 tray_area_min = vec2(0);
uniform vec2 tray_area_max = vec2(1);

group_uniforms wave;
uniform float wave_pos = .5;
uniform float distortion: hint_range(0.0, 50.0, 1.0) = 1.0;
uniform float wave_length: hint_range(0.0, 500.0, 1.0) = 10.0;
uniform float distortion_decay: hint_range(0.0, 500.0, 1.0) = 10.0;
uniform float wave_length_decay: hint_range(0.0, 50.0, 0.1) = 10.0;

group_uniforms ripple;
uniform sampler2D noise_texture;
uniform float noise_strength;
uniform float noise_speed = .35;

group_uniforms tray_tilt;
uniform float tilt: hint_range(0.0, 1.0, .1) = 0.0;
uniform float tilt_strength: hint_range(0.1, 5.0, 0.01) = 1.0;

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

vec2 uv_to_pixel_coord(vec2 uv, vec2 pixel_size){
	return uv / pixel_size;
}

vec2 pixel_coord_to_uv(vec2 coord, vec2 pixel_size){
	return coord * pixel_size;
}

vec2 get_ripple(vec2 uv, vec2 screen_size){
	// add noise
	float time = fract(TIME * noise_speed);
	vec2 noise_uv = fract(uv + time);
	vec2 noise = texture(noise_texture, noise_uv).xy * noise_strength;
	float shadow = pow(texture(noise_texture, noise_uv).r, 2.0);
	
	uv = uv_normalized_to_proportional(uv, screen_size);
	uv += noise;
	uv = uv_proportional_to_normalized(uv, screen_size);
	
	return uv;
}

vec2 get_wave(vec2 uv, vec2 screen_size){
	vec2 coord = uv_to_pixel_coord(uv, screen_size);
	vec2 wave_coord = uv_to_pixel_coord(vec2(0.0, wave_pos), screen_size);

	float offset = coord.y - wave_coord.y;
	
	// increase wavelength over time
	float wl_decay = 1.0 / exp(-(abs(offset) - wave_length)/wave_length_decay) + 1.0;

	// make a regular wave
	float wave = cos(2.0 * PI  * offset / (wave_length * wl_decay));
	float wave_color = (cos(2.0 * PI  * offset / (wave_length * wl_decay)) + 1.0) / 2.0;

	// decay wave strength based on distance
	float decay = exp(-abs(offset)/distortion_decay);
	wave *= decay;
	wave_color *= decay;

	offset += wave * distortion;

	coord.y = offset + wave_coord.y;
	uv = pixel_coord_to_uv(coord, screen_size);
	return uv;
}

vec2 get_tilt(vec2 uv, vec2 screen_uv, vec2 screen_size)
{
	uv = uv_normalized_to_proportional(uv, screen_size);
	float offset = clamp(screen_uv.y - tilt_axis, -1.0, 1.0);
	uv.x /= 1.0 + offset * tilt * tilt_strength;
	uv.y /= 1.0 + sign(offset) * tilt * tilt_strength * .078;
	uv = uv_proportional_to_normalized(uv, screen_size);
	return uv;
}

bool is_in_bounding_area(vec2 uv){
	return 
		uv.x >= tray_area_min.x 
		&& uv.y >= tray_area_min.y 
		&& uv.x <= tray_area_max.x 
		&& uv.y <= tray_area_max.y;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	if (is_in_bounding_area(uv)){
		uv = get_ripple(SCREEN_UV, SCREEN_PIXEL_SIZE);
		uv = get_wave(uv, SCREEN_PIXEL_SIZE);
	}
	uv = get_tilt(uv, SCREEN_UV, SCREEN_PIXEL_SIZE);
	COLOR = texture(screen_texture, uv);
	
	if (debug) {
		if (is_in_bounding_area(SCREEN_UV)){
			COLOR = mix(COLOR, vec4(0.0, 1.0, 0.0, 1.0), .1);
		}
		if (abs(SCREEN_UV.y - tilt_axis) <= 0.001){
			COLOR = mix(COLOR, vec4(1.0, 0.0, 0.0, 1.0), 1.0);
		}
		if (abs(SCREEN_UV.y - wave_pos) <= 0.001){
			COLOR = mix(COLOR, vec4(0.0, 0.0, 1.0, 1.0), 1.0);
		}
	}
}
