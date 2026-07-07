shader_type spatial;

global uniform sampler2DArray texture_array : filter_nearest_mipmap, source_color;
varying flat float index;

void fragment() {
	ALBEDO = texture(texture_array, vec3(UV, index)).rgb;
}

void vertex() {
	index = UV2.x;
}
