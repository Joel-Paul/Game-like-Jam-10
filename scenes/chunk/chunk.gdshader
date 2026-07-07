shader_type spatial;

global uniform sampler2DArray texture_array : filter_nearest_mipmap, source_color;

void fragment() {
	ALBEDO = texture(texture_array, vec3(UV, float(0))).rgb;
}