shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 textureColor = texture(TEXTURE, UV);
	COLOR = vec4(textureColor.r,1.0,1.0,0.8);
}


