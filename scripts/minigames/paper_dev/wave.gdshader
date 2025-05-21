shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform vec2 wave_uv = vec2(.5, .5);
uniform float wave_length: hint_range(10.0, 50.0, 1.0) = 10.0;
uniform float max_distortion: hint_range(0.0, 50.0, 1.0) = 1.0;
//uniform float fall_off: hint_range(0.0, 1.0, 0.1)

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
	if (abs(uv.y - wave_uv.y) <= 0.001)
	{
		COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	}
	else {
		vec2 coord = uv_to_pixel_coord(uv, SCREEN_PIXEL_SIZE);
		vec2 wave_coord = uv_to_pixel_coord(wave_uv, SCREEN_PIXEL_SIZE);
		
		float offset = coord.y - wave_coord.y;
		
		float wave_factor = cos(2.0 * PI * offset / wave_length);
		float distance_factor = abs(offset) - wave_length;
		
		float distortion = max_distortion * wave_factor * distance_factor;
		offset += distortion * -sign(offset);
		
		coord.y = offset + wave_coord.y;
		
		uv = pixel_coord_to_uv(coord, SCREEN_PIXEL_SIZE);
		
		COLOR = texture(screen_texture, uv);
	}
	
	
}