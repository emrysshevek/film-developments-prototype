shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform vec2 wave_uv = vec2(.5, .5);
uniform float distortion: hint_range(0.0, 50.0, 1.0) = 1.0;
uniform float wave_length: hint_range(0.0, 500.0, 1.0) = 10.0;
uniform float distortion_decay: hint_range(0.0, 500.0, 1.0) = 10.0;
uniform float wave_length_decay: hint_range(0.0, 50.0, 0.1) = 10.0;

uniform sampler2D noise_texture;
uniform float noise_strength;
uniform float noise_speed = .35;

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

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 coord = uv_to_pixel_coord(uv, SCREEN_PIXEL_SIZE);
	vec2 wave_coord = uv_to_pixel_coord(wave_uv, SCREEN_PIXEL_SIZE);

	//float dir = sign(coord.y - wave_coord.y);
	float offset = coord.y - wave_coord.y;

	float shadow = 0.0;

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
	shadow += wave * .1;

	coord.y = offset + wave_coord.y;
	uv = pixel_coord_to_uv(coord, SCREEN_PIXEL_SIZE);


	// add noise
	float time = fract(TIME * noise_speed);
	vec2 noise_uv = (uv + time) / 2.0;
	float noise = texture(noise_texture, noise_uv).x * noise_strength;
	shadow += pow(texture(noise_texture, noise_uv).r, 2.0);

	uv = uv_normalized_to_proportional(uv, SCREEN_PIXEL_SIZE);
	uv *= 1.0 + noise;
	uv = uv_proportional_to_normalized(uv, SCREEN_PIXEL_SIZE);
	//COLOR = vec4(vec3(noise), 1);
	COLOR = mix(texture(screen_texture, uv), vec4(vec3(0), 1), clamp(shadow * .7, 0.0, 1.0));

	if (abs(SCREEN_UV.y - wave_uv.y) <= 0.001)
	{
		COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	}

}