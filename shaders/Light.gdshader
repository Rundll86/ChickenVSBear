shader_type canvas_item;
uniform vec4 color:source_color;
uniform float mixProgress:hint_range(0.0, 1.0, 0.01)=0.5;
void fragment() {
	float maxDistance=0.5;
	float dist=distance(UV,vec2(0.5));
	vec4 mixed=vec4(color.rgb,smoothstep(0,1,(maxDistance-dist)/maxDistance));
	COLOR=mix(COLOR,mixed,mixProgress);
}