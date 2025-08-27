shader_type canvas_item;
uniform vec4 color: source_color;
uniform float laser_width: hint_range(0.01, 1.0) = 0;
uniform float soft_edge: hint_range(0.0, 0.5) = 0.5;
void fragment() {
	float textureWidth=float(textureSize(TEXTURE,0).x);
	float textureHeight=float(textureSize(TEXTURE,0).y);
	float radius=textureHeight/2.0;
	float radiusU=radius*TEXTURE_PIXEL_SIZE;
    float dist = distance(vec2(0.5,clamp(UV.y,radiusU,1.0-radiusU)),UV);
    float core = 1.0 - smoothstep(0.0, laser_width, dist);
    float edge=1.0 - smoothstep(laser_width, laser_width + soft_edge, dist);
	float alpha = max(core, edge);
    COLOR = color;
    COLOR.a = alpha;
}