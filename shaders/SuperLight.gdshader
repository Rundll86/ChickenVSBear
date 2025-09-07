shader_type canvas_item;
uniform float k : hint_range(-10.0, 10.0) = 1.0;
uniform vec4 color : source_color = vec4(1.0);
uniform float scale : hint_range(10.0, 500.0) = 100.0;
void fragment() {
    vec2 pos = (UV - 0.5) * scale;
    float y1 = k / pos.x;
    float y2 = -k / pos.x;
    bool in_region = false;
    if (pos.x > 0.0) {
        if ((pos.y > y2 && pos.y < y1) || (pos.y < y2 && pos.y > y1)) {
            in_region = true;
        }
    }
    else if (pos.x < 0.0) {
        if ((pos.y > y1 && pos.y < y2) || (pos.y < y1 && pos.y > y2)) {
            in_region = true;
        }
    }
    if (in_region) {
        COLOR = color;
    } else {
        COLOR = vec4(0.0);
    }
	COLOR.a*=(0.5-distance(UV,vec2(0.5)))/0.5;
}
