shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int mode = 0;
void fragment() {
	vec4 px = texture(SCREEN_TEXTURE, SCREEN_UV);
	if (mode==1) { px = px.gbra; }
	if (mode==2) { px = px.brga; }
	if (mode==3) { px = px.bgra; }
	COLOR = vec4(px.rgb,1.0);
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
