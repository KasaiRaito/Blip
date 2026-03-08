shader_type canvas_item;
uniform vec3 my_custom_color : source_color;

void fragment() {
	COLOR = vec4(my_custom_color.r, my_custom_color.g, my_custom_color.b, texture(TEXTURE, UV).a);
}