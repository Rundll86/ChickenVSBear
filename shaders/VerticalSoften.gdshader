shader_type canvas_item;
uniform vec2 percent=vec2(0,1);
void fragment(){
	COLOR=vec4(0,0,0,1);
	if(UV.y<percent.x){
		COLOR.a*=UV.y/percent.x;
	}else if(UV.y>percent.y){
		COLOR.a*=1.0-(distance(UV.y,percent.y))/(1.0-percent.y);
	}
}