shader_type canvas_item;
uniform float inner:hint_range(0.0, 1.0, 0.01)=0.5;
uniform float outer:hint_range(0.0, 1.0, 0.01)=0.75;
uniform float alpha:hint_range(0.0, 1.0, 0.1)=0.5;
void fragment() {
	vec2 center=vec2(0.5);
	float dist=distance(UV,center)*2.0;
	if(dist<inner){
		COLOR.a*=alpha;
	}else{
		COLOR.a*=float(inner<dist&&dist<outer);
	}
}