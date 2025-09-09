shader_type canvas_item;
uniform float progress:hint_range(-0.0, 2.0, 0.01)=0.5;
uniform float backAlpha:hint_range(0.0, 1.0, 0.01)=0.25;
uniform float edgeHeight:hint_range(0.0, 1.0, 0.01)=0.05;
uniform float trailHeight:hint_range(0.0, 1.0, 0.01)=0.3;
uniform float trailAlpha:hint_range(0.0, 1.0, 0.01)=0.5;
void fragment() {
	if(UV.y>=1.0-progress){
		if(1.0-progress+trailHeight-UV.y>0.0){
			float dist=distance(UV.y,1.0-progress);
			COLOR=vec4(1);
			COLOR.a=(trailHeight-dist)/trailHeight*trailAlpha;
		}else{
			COLOR.a*=backAlpha;
		}
	}else if(distance(UV.y,1.0-progress)<edgeHeight){
		COLOR=vec4(1.0);
	}
}