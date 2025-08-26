shader_type canvas_item;
uniform int pixelSize;

void fragment() {
    vec2 uv = UV - mod(UV, vec2(float(pixelSize)) / vec2(textureSize(TEXTURE, 0)));
    COLOR = texture(TEXTURE, uv);
}