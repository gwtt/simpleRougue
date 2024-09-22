shader_type canvas_item;
uniform float alpha;
void vertex() {
	
}
void fragment() {
  //采样      
  vec4 textureColor = texture(TEXTURE, UV);
  //控制透明度
  COLOR.a = mix(textureColor.a,0, alpha);
}