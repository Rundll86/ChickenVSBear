shader_type canvas_item;
uniform vec4 color:source_color;
void fragment() {
	vec2 center=vec2(UV.x,0.5);
	float maxDist=0.5;
	float dist=distance(UV,center);
	COLOR=color;
	COLOR.a*=(maxDist-dist)/maxDist;
}