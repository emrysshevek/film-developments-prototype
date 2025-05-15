shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;

uniform float blur_strength = 0.0;

vec3 get_original(vec2 screen_uv, float lod)
{
	return texture(screen_texture, screen_uv, lod).rgb;
}

float get_depth(vec2 screen_uv, mat4 inv_projection_matrix)
{
	float depth = texture(depth_texture, screen_uv).r;
	return mix(0.0, 5.0, depth);
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(screen_uv, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	#endif
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= -view.w;
	return -view.z;
}

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	float depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	//float linear_depth = mix(0.0, 5.0, depth);

  // Visualize linear depth
	//ALBEDO = vec3(1.0 - fract(depth));
 	//ALBEDO = get_original(SCREEN_UV, blur_strength);
	ALBEDO = get_original(SCREEN_UV, 1.0 - fract(depth));

  // Visualize world coordinates
  //ALBEDO.rgb = fract(world_position).xyz;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
