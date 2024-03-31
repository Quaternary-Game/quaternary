shader_type canvas_item;

uniform float lod : hint_range(0.0,5) = 0;

void fragment() {
	COLOR = texture(TEXTURE, UV, lod);
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
