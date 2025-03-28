shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D normal_texture : hint_normal_roughness_texture;

uniform float depth_threshold;

vec3 get_original(vec2 screen_uv)
{
	return texture(screen_texture, screen_uv).rgb;
}

vec3 get_normal(vec2 screen_uv)
{
	return texture(normal_texture, screen_uv).rgb * 2.0 - 1.0;
}

float get_depth(vec2 screen_uv, mat4 inv_projection_matrix)
{
	float depth = texture(depth_texture, screen_uv).r;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(screen_uv, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	#endif
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= -view.w;
	return view.z;
}

float get_outline(vec2 screen_uv, mat4 inv_projection_matrix, vec2 viewport_size)
{
	float depth = get_depth(screen_uv, inv_projection_matrix);
	vec3 normal = get_normal(screen_uv);
	
	// GET SURROUNDING TEXEL
	vec2 texel_size = 1.0 / viewport_size.xy;
	vec2 uvs[4]; // array containing the uvs of the surrounding pixels
	uvs[0] = vec2(screen_uv.x, screen_uv.y + texel_size.y);
	uvs[1] = vec2(screen_uv.x, screen_uv.y - texel_size.y);
	uvs[2] = vec2(screen_uv.x + texel_size.x, screen_uv.y);
	uvs[3] = vec2(screen_uv.x - texel_size.x, screen_uv.y);

	// EDGE DETECTION
	float depth_diff = 0.0;
	float normal_sum = 0.0;
	
	for(int i = 0; i < 4; i++)
	{
		float d = get_depth(uvs[i], inv_projection_matrix);
		depth_diff += depth - d;
		
		vec3 n = get_normal(uvs[i]);
		vec3 normal_diff = normal - n;
		
		vec3 normal_edge_bias = vec3(1.0, 1.0, 1.0);
		float normal_bias_diff = dot(normal_diff, normal_edge_bias);
		float normal_indicator = smoothstep(-0.01, 0.01, normal_bias_diff);
		
		normal_sum += dot(normal_diff, normal_diff) * normal_indicator;
	}
	float depth_edge = step(depth_threshold, depth_diff);
	
	
	return depth_edge + normal_sum;
}

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	// SCREEN TEXTURE
	vec3 original = get_original(SCREEN_UV);
	
	// NORMAL
	vec3 normal = get_normal(SCREEN_UV);
	
	// DEPTH
	float depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);

	// EDGE
	float outline = get_outline(SCREEN_UV, INV_PROJECTION_MATRIX, VIEWPORT_SIZE);

	ALBEDO = mix(original, vec3(0.0), outline);
	//ALBEDO = vec3(ossssutline);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
