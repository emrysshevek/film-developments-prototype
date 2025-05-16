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

uniform float focus_circle_radius = 75.0;
uniform float focus_circle_strength = .25;

uniform float blur_strength = 1.0;

uniform bool show_focus_ring = true;

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
	vec2 uv = SCREEN_UV;
	
	// https://en.wikipedia.org/wiki/Depth_of_field#Foreground_and_background_blur
	float D = get_depth(uv, INV_PROJECTION_MATRIX); // distance to foreground/background
	float x_d = D - u;
	float b = (f / N) * (abs(x_d) / (u + x_d));
	
	if (show_focus_ring){
		uv = uv_normalized_to_proportional(SCREEN_UV, VIEWPORT_SIZE);
		if (distance(uv, vec2(0)) <= focus_circle_radius){
			uv *= b * sign(x_d) * focus_circle_strength;
		}
		
		uv = uv_proportional_to_normalized(uv, VIEWPORT_SIZE);
		
		D = get_depth(uv, INV_PROJECTION_MATRIX); // distance to foreground/background
	}
	
	// https://en.wikipedia.org/wiki/Depth_of_field#Foreground_and_background_blur
	x_d = D - u;
	b = (f / N) * (abs(x_d) / (u + x_d));
	
	//Blur based on distance from subject
	ALBEDO = get_original(uv, min(b * blur_strength, 3.0));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
