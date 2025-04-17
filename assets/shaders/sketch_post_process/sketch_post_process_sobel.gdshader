shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D normal_texture : hint_normal_roughness_texture;

uniform vec3 background_color: source_color;
uniform vec3 line_color: source_color;
uniform sampler2D noise_texture;
uniform sampler2D value_gradient;
uniform sampler2D hatch;
uniform float hatch_density = 1.8;

uniform float outline_thickness = 1.0;
uniform float depth_threshold = .5;
uniform float rgb_threshold = .5;
uniform float normal_threshold = .5;

uniform float frame_time = .35;

const vec2 sobel_sample_points[9] = {
	vec2(-1,1),vec2(0,1),vec2(1,1),
	vec2(-1,0),vec2(0,0),vec2(1,1),
	vec2(-1,-1),vec2(0,-1),vec2(1,-1)
};

const float[9] sobel_x = {
	1.0, 0.0, -1.0,
	2.0, 0.0, -2.0,
	1.0, 0.0, -1.0
};

const float[9] sobel_y = {
	1.0, 2.0, 1.0,
	0.0, 0.0, 0.0,
	-1.0, -2.0, -1.0
};

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
	//view.xyz /= 100.0;
	return -view.z;
}

float get_outline(vec2 screen_uv, mat4 inv_projection_matrix, mat4 inv_view_matrix, vec2 viewport_size)
{
	vec2 texel_size = outline_thickness / viewport_size.xy;

	float depth = get_depth(screen_uv, inv_projection_matrix);
	vec3 normal = get_normal(screen_uv);
	vec3 color = get_original(screen_uv);

	vec2 sobelr = vec2(0.0);
	vec2 sobelg = vec2(0.0);
	vec2 sobelb = vec2(0.0);

	vec2 sobelnx = vec2(0.0);
	vec2 sobelny = vec2(0.0);
	vec2 sobelnz = vec2(0.0);

	vec2 sobeld = vec2(0.0);

	// EDGE DETECTION

	for(int i = 0; i < 9; i++)
	{
		// Get correct pixel from neighbors
		vec2 uv = screen_uv + (sobel_sample_points[i] * texel_size);
		vec2 kernel = vec2(sobel_x[i], sobel_y[i]);

		// Run Sobel on depth value
		float depth = get_depth(uv, inv_projection_matrix);
		sobeld += depth * kernel;

		//Run sobel on rgb values
		vec3 rgb = get_original(uv);
		sobelr += rgb.r * kernel;
		sobelg += rgb.g * kernel;
		sobelb += rgb.b * kernel;

		// Run sobel on normal value
		vec3 normal = get_normal(uv);
		sobelnx += normal.x * kernel;
		sobelny += normal.y * kernel;
		sobelnz += normal.z * kernel;

	}

	float depth_edge = step(depth_threshold, length(sobeld));
	float rgb_edge = step(rgb_threshold, max(length(sobelr), max(length(sobelg), length(sobelb))));
	float normal_edge = step(normal_threshold, max(length(sobelnx), max(length(sobelny), length(sobelnz))));

	return depth_edge + normal_edge + rgb_edge;
}

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	// SCREEN TEXTURE

	float rounded_time = round(TIME / frame_time) * frame_time;
	vec2 noise = texture(noise_texture, SCREEN_UV + rounded_time).xy / 200.0;
	vec2 uv = SCREEN_UV + noise;

	// HATCHING
	vec3 original = get_original(uv);
	float value = (original.r + original.g + original.b) / 3.0;
	float hatch_value = 0.0;
	if(value > .2)
	{
		hatch_value += texture(hatch, uv * hatch_density).r;
	}
	if(value > .4)
	{
		hatch_value +=  texture(hatch, uv * hatch_density).g;
	}
	if(value > .6)
	{
		hatch_value += texture(hatch, uv * hatch_density).b;
	}
	hatch_value = clamp(hatch_value, 0.0, 1.0);

	// EDGE
	float outline = get_outline(uv, INV_PROJECTION_MATRIX, INV_VIEW_MATRIX, VIEWPORT_SIZE);

	//ALBEDO = mix(original, vec3(0.0), outline + hatch_value);
	//ALBEDO = vec3(step(.1, value));
	ALBEDO = mix(background_color, line_color, outline + hatch_value);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
