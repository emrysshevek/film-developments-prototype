shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;

// CAMERA VARIABLES
// https://en.wikipedia.org/wiki/Depth_of_field#Factors_affecting_depth_of_field
uniform float c = .003; // acceptable circle of confusion
uniform float f = 50.0; // focal length
uniform float N = 3.2; // f-number
uniform float u = 1.0; // distance to subject

uniform float blur_strength = 1.0;
uniform float focus_dist = 1.0;

vec3 get_original(vec2 screen_uv, float lod)
{
	return texture(screen_texture, screen_uv, lod).rgb;
}

float get_depth(vec2 screen_uv, mat4 inv_projection_matrix)
{
	float depth = texture(depth_texture, screen_uv).r;
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	#endif
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
  	//view.xyz /= -view.w;
	return (view.xyz / -view.w).z;
}

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	float D = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX); // distance to foreground/background
	
	// https://en.wikipedia.org/wiki/Depth_of_field#Factors_affecting_depth_of_field
	float dof = 2.0 * pow(u, 2.0) * N * c / pow(f, 2.0);
	// https://en.wikipedia.org/wiki/Hyperfocal_distance#Formula
	float H = pow(f, 2.0) / (N * c) + f; // hyperfocal distance
	
	// https://en.wikipedia.org/wiki/Depth_of_field#Foreground_and_background_blur
	float x_d = D - u;
	float b = (f / N) * (abs(x_d) / (u + x_d));

  // Visualize linear depth
 	//ALBEDO = vec3(b * blur_strength);
	ALBEDO = get_original(SCREEN_UV, min(b * blur_strength, 5.0));

  // Visualize world coordinates
  //ALBEDO = get_original(SCREEN_UV, 0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
