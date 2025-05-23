shader_type canvas_item;


uniform float radius: hint_range(0.0, 1.0, 0.1) = .75;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	
	vec2 uv = (SCREEN_UV * 2.0 - 1.0) * (SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE);
	if (distance(uv, vec2(0)) > radius || distance(uv.y, 0) <= .01){
		COLOR = vec4(vec3(0), 1.0);
	}
}
