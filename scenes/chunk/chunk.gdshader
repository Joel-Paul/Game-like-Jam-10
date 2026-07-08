shader_type spatial;

global uniform sampler2DArray texture_array : filter_nearest_mipmap, source_color;
varying flat float index;

void fragment() {
	vec4 tex = texture(texture_array, vec3(UV, index));
	ALBEDO = tex.rgb;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
	ALPHA = tex.a;
}

void vertex() {
	index = UV2.x;
}
