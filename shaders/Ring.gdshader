shader_type canvas_item;
uniform float inner:hint_range(0.0, 1.0, 0.01)=0.5;
uniform float outer:hint_range(0.0, 1.0, 0.01)=0.75;
void fragment() {
	vec2 center=vec2(0.5);
	float dist=distance(UV,center)*2.0;
	COLOR.a=float(inner<dist&&dist<outer);
}