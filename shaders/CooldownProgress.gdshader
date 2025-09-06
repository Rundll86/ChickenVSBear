shader_type canvas_item;
uniform float progress:hint_range(0.0, 2.0, 0.01)=0.5;
uniform float backAlpha:hint_range(0.0, 1.0, 0.01)=0.25;
uniform float edgeHeight:hint_range(0.0, 1.0, 0.01)=0.05;
uniform float trailHeight:hint_range(0.0, 1.0, 0.01)=0.3;
void fragment() {
	if(UV.y>=progress){
		COLOR.a*=backAlpha;
	}else if(distance(UV.y,progress)<edgeHeight){
		COLOR.rgb*=255.0;
	}else if(progress-UV.y<=trailHeight){
		COLOR.rgb*=1.0+(trailHeight/(progress-UV.y)-1.0)*0.5;
	}
}