shader_type canvas_item;

void fragment() {
	COLOR=vec4(vec2(textureSize(TEXTURE,0)),0,1);
}
