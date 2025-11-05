shader_type canvas_item;
render_mode blend_add;

// --- Uniforms (可在编辑器中调整的参数) ---

// 水晶的基础颜色
uniform vec4 crystal_color : source_color = vec4(0.4, 0.8, 1.0, 1.0);
// 内部辉光的颜色
uniform vec4 glow_color : source_color = vec4(0.8, 0.9, 1.0, 1.0);
// 高光的颜色
uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// 控制水晶的整体大小
uniform float scale = 1.0;
// 控制折射/扭曲的强度
uniform float distortion_strength = 0.05;
// 控制内部细节的复杂度
uniform float detail_noise_scale = 8.0;
// 控制闪烁的速度
uniform float flicker_speed = 2.0;


// --- Helper Functions (辅助函数) ---

// 一个简单的伪随机数生成器
float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 2D 噪声函数，用于创建有机的内部纹理
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // 四个角的随机值
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // 平滑插值
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}


// --- Main Shader Logic ---
void fragment() {
    // 1. 将 UV 坐标归一化到 [-1, 1] 范围，并调整宽高比
    vec2 uv = (UV - 0.5) * 2.0;
    uv.x *= SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
    uv /= scale;

    // 2. 定义水晶的形状 (这里使用心形线作为基础，你也可以换成其他形状)
    // 心形线公式: (x^2 + y^2 - 1)^3 - x^2 * y^3 = 0
    float heart_shape = (pow(uv.x * uv.x + uv.y * uv.y - 1.0, 3.0) - uv.x * uv.x * pow(uv.y, 3.0));
    
    // 使用 smoothstep 创建一个柔和的边缘
    float crystal_mask = 1.0 - smoothstep(-0.1, 0.1, heart_shape);

    // 3. 创建内部折射/扭曲效果
    // 我们对坐标进行轻微的扰动，然后对水晶本身进行采样
    vec2 distorted_uv = uv + vec2(noise(uv * detail_noise_scale + TIME * 0.1), 
                                  noise(uv * detail_noise_scale + TIME * 0.1 + 100.0)) * distortion_strength;
    float distorted_heart_shape = (pow(distorted_uv.x * distorted_uv.x + distorted_uv.y * distorted_uv.y - 1.0, 3.0) - distorted_uv.x * distorted_uv.x * pow(distorted_uv.y, 3.0));
    float refraction_mask = 1.0 - smoothstep(-0.1, 0.1, distorted_heart_shape);
    
    // 4. 创建内部辉光和细节
    // 使用噪声创建内部纹理
    float internal_noise = noise(uv * detail_noise_scale - TIME * 0.2);
    // 将噪声值限制在水晶形状内
    float internal_glow = internal_noise * crystal_mask;
    // 增强辉光效果
    internal_glow = pow(internal_glow, 2.0);

    // 5. 创建高光
    // 定义一个高光区域
    vec2 highlight_pos = uv - vec2(-0.2, 0.3); // 高光位置
    float highlight = 1.0 - smoothstep(0.0, 0.15, length(highlight_pos));
    // 让高光也受噪声影响，看起来不那么死板
    highlight *= (1.0 + noise(highlight_pos * 10.0) * 0.5);
    // 高光也必须在水晶形状内
    highlight *= crystal_mask;
    // 让高光更锐利
    highlight = pow(highlight, 8.0);

    // 6. 创建闪烁效果
    float flicker = 1.0 + (noise(vec2(TIME * flicker_speed)) - 0.5) * 0.2;

    // 7. 组合所有颜色
    vec4 final_color = vec4(0.0);
    
    // 基础水晶颜色
    final_color += crystal_color * crystal_mask;
    
    // 叠加内部辉光
    final_color += glow_color * internal_glow * 0.5;
    
    // 叠加高光
    final_color += highlight_color * highlight;
    
    // 应用闪烁
    final_color *= flicker;

    // 8. 输出最终颜色
    // 由于我们使用了 blend_add 混合模式，背景会自动透出
    COLOR = final_color;
}
