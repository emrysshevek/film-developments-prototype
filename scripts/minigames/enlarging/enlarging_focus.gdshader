shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float radius: hint_range(0.0, 1.0, 0.1) = .75;
uniform float lod = 0.0;

void fragment() {
	vec2 uv = (SCREEN_UV * 2.0 - 1.0) * (SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE);
	COLOR = texture(screen_texture, SCREEN_UV, lod);
	if (distance(uv, vec2(0)) > radius){
		COLOR = vec4(vec3(0), 1.0);
	}
}
