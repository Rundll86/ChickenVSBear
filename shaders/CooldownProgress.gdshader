shader_type canvas_item;
uniform float progress:hint_range(-0.0, 2.0, 0.01)=0.5;
uniform float backAlpha:hint_range(0.0, 1.0, 0.01)=0.1;
uniform float edgeHeight:hint_range(0.0, 1.0, 0.01)=0.06;
uniform vec4 edgeColor:source_color;
uniform float trailHeight:hint_range(0.0, 1.0, 0.01)=0.4;
void fragment() {
	if(UV.y>=1.0-progress){
		if(distance(UV,vec2(0.5,0.5))>0.5-edgeHeight){
			COLOR=vec4(1,1,1,1);
		}else if(1.0-progress+trailHeight-UV.y>0.0){
				float dist=UV.y-(1.0-progress);
				COLOR=vec4(1,1,1,(trailHeight-dist)/trailHeight*0.8);
		}else{
			COLOR.a*=backAlpha;
		}
	}else if(distance(UV.y,1.0-progress)<edgeHeight){
		COLOR=edgeColor;
	}
}