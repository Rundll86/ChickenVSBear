shader_type canvas_item;
uniform float progress:hint_range(0.0, 1.0, 0.01)=0.5;
void fragment() {
	COLOR=texture(TEXTURE,UV);
	if(UV.y>=progress){
		COLOR.a*=0.5;
	}
}