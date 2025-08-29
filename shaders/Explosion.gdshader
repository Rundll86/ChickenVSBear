shader_type canvas_item;

uniform float explosion_radius : hint_range(0.0, 1.0) = 0.0;
uniform float explosion_intensity : hint_range(0.0, 2.0) = 1.0;
uniform vec4 explosion_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float time_scale = 1.0;

void fragment() {
    // 计算当前像素到中心的距离
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // 使用TIME创建随时间变化的爆炸效果
    float time = TIME * time_scale;
    float explosion = smoothstep(explosion_radius, explosion_radius - 0.2, dist) * explosion_intensity;
    
    // 添加一些噪声使爆炸看起来更自然
    float noise = sin(dist * 20.0 - time * 5.0) * 0.5 + 0.5;
    explosion *= noise;
    
    // 限制explosion值在0-1范围内
    explosion = clamp(explosion, 0.0, 1.0);
    
    // 计算最终颜色，混合原始纹理和爆炸效果
    vec4 original_color = texture(TEXTURE, UV);
    vec4 final_color = mix(original_color, explosion_color, explosion);
    
    // 添加一些发光效果
    float glow = exp(-dist * 5.0) * explosion_intensity;
    final_color.rgb += glow * explosion_color.rgb;
    
    // 确保alpha通道正确设置
    final_color.a = max(original_color.a, explosion);
    
    // 输出最终颜色
    COLOR = final_color;
}
