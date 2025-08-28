shader_type canvas_item;
render_mode blend_add;

uniform vec4 laser_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // 边缘颜色
uniform float width : hint_range(0.01, 1.0) = 0.1; // 激光宽度
uniform float softness : hint_range(0.01, 1.0) = 0.2; // 边缘柔和度
uniform float wave_speed : hint_range(-10.0, 10.0) = 2.0; // 波传播速度
uniform float wave_frequency : hint_range(1.0, 20.0) = 8.0; // 波频率
uniform float wave_amplitude : hint_range(0.1, 2.0) = 0.5; // 波幅度
uniform float wave_width : hint_range(0.01, 0.5) = 0.1; // 波宽度

void fragment() {
    // 将UV坐标转换为以激光中心为原点的坐标
    vec2 uv = UV - vec2(0.5, 0.0);
    
    // 计算激光基础强度（中心白色，边缘渐变到laser_color）
    float dist = abs(uv.x) / width;
	float x_dist=abs(UV.x-0.5);
    float laser_intensity = 1.0 - smoothstep(0.0, softness, dist);
    
    // 计算波的位置（沿Y轴传播）
    float wave_pos = mod(TIME * wave_speed, 1.0);
    
    // 计算当前点到波中心的距离（在Y轴上的距离）
    float wave_dist = abs(uv.y - wave_pos);
    
    // 计算波强度（高斯分布）
    float wave_intensity = exp(-wave_dist * wave_dist / (2.0 * wave_width * wave_width));
    
    // 添加波的弧形效果（在X轴上的分布）
    wave_intensity *= exp(-uv.x * uv.x / (2.0 * (width * 0.5) * (width * 0.5)));
    
    // 应用波频率和幅度
    wave_intensity *= sin(wave_dist * wave_frequency * 3.14159) * wave_amplitude;
    
    // 组合激光和波效果
    float total_intensity = laser_intensity + wave_intensity;
    
    // 颜色混合：中心白色，边缘渐变到laser_color
    vec3 base_color = mix(vec3(1.0), laser_color.rgb, 1.0 - laser_intensity);
    vec3 color = base_color + vec3(wave_intensity);
    
    // 设置最终颜色（加法混合模式会忽略alpha）
    COLOR = vec4(color, 0.5-x_dist);
}
