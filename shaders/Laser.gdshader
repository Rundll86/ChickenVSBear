shader_type canvas_item;
uniform vec4 color: source_color;
uniform float laser_width: hint_range(0.01, 1.0) = 0;
uniform float soft_edge: hint_range(0.0, 0.5) = 0.5;
void fragment() {
    float dist = abs(UV.x - 0.5);
    float core = 1.0 - smoothstep(0.0, laser_width, dist);
    float edge = 1.0 - smoothstep(laser_width, laser_width + soft_edge, dist);
    float alpha = max(core, edge);
    COLOR = color;
    COLOR.a = alpha;
}