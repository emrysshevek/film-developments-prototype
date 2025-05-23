shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_texture: filter_linear_mipmap;
uniform sampler2D noise_texture2: filter_linear_mipmap;

vec4 get_grain(vec2 uv){
	vec4 color = texture(screen_texture, uv);
	//color = update_contrast(color);
	float value = (color.r + color.g + color.b) / 3.0;
	float noise = texture(noise_texture, uv, .3).x;
	float noise2 = texture(noise_texture2, uv, .3).x;
	float result = 1.0 - value;
	result = mix(1.0, noise2, (noise - result) + .5);
	return vec4(vec3(result), 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 grain = get_grain(SCREEN_UV);
	grain.rgb = mix(vec3(0.5), grain.rgb, 1.0);
	COLOR = grain;
}