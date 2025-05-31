## GDScript代码规范
一律采用godot4.x语法
## shader规范
// https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html
// https://docs.godotengine.org/zh-cn/4.x/tutorials/shaders/shader_reference/shading_language.html
// 声明 Shader 类型
shader_type spatial;


render_mode unshaded; // 无阴影
render_mode cull_disabled; // 禁用面剔除
render_mode depth_test_disabled; // 禁用深度测试


// 暴露变量
instance uniform float ins; // instance 关键字允许每个实例单独修改
uniform float is_float : hint_range(0.0, 1.0, 0.1) = 0.0; // 变量范围
uniform bool is_bool; // 布尔变量
uniform vec4 flash_color: source_color = vec4(1.0); // 颜色变量 hint_color
uniform sampler2D pattern_sampler: source_color; // 贴图
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_nearest;


varying float ver; // 顶点着色器传递数据到片段着色器的变量
const float pi = 3.14; // 常量
//#include "res://test.gdshaderinc" // 导入一个着色器脚本


// 顶点
void vertex()
{
	COLOR = vec4(UV, 0.0, 1.0); // 显示 UV 颜色
	COLOR = texture(SCREEN_TEXTURE, UV); // 显示纹理颜色
	VERTEX = vec3(0.0,1.0,0.0); //局部顶点坐标
	NORMAL = vec3(0.0,1.0,0.0); //顶点法向
	vec3 world = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz; //局部空间转换到世界空间
	vec4 local = vec4(world,0.0) * MODEL_MATRIX; //世界空间转换到局部空间


//	float VdotN = dot(VIEW, NORMAL); //视角法向夹角大小


	// 将屏幕 UV 还原
//	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
//	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);


	// 一下为版本置换
	mat4 WORLD_MATRIX = MODEL_MATRIX; // 模型空间转换为世界空间
	mat4 CAMERA_MATRIX = INV_VIEW_MATRIX; // 视图空间转换为世界空间
	mat4 INV_CAMERA_MATRIX = VIEW_MATRIX; // 世界空间转换为视图空间
	INV_PROJECTION_MATRIX; // 裁剪空间转换为视图空间
	// vec4 TRANSMISSION = SSS_TRANSMITTANCE_COLORl;
	// 裁剪空间：视锥区域，坐标范围为 -1 到 1，Z轴为 0 到 1 的非线性过度
	// 视图空间：相机为原点且面向 -z 轴
	// 世界空间：标准世界坐标轴
	// 模型空间：模型的局部空间
	// 屏幕空间：屏幕的二维坐标
}


// 着色
void fragment() {
	discard; // 丢弃该像素的渲染


	VERTEX; // 表面相对屏幕的位置
	COLOR; // 顶点色
	FRAGCOORD.xy; // 像素点坐标
	SCREEN_UV; // 屏幕UV
	NODE_POSITION_WORLD; // 节点在世界空间的位置
	NODE_POSITION_VIEW; // 节点在视图空间的位置
	CAMERA_POSITION_WORLD; // 相机在世界空间的位置
	CAMERA_DIRECTION_WORLD; // 相机在世界空间的方向
	FRONT_FACING; // 是否面朝相机
	// 变量
	float a = 1.0;
	float b = 2.0;
	vec4 color = vec4(1,1,1,1);
	step(a, b); // 如果b >= a,返回 1.0;否则返回 0.0
	max(a, b); // 返回 a 和 b 中的最大值
	mix(a, b, 0.5); // 插值
	round(a); // 四舍五入
	floor(a); // 向下取整
	ceil(a); // 向上取整
	clamp(3.5, a, b); // 钳制
	pow(2.0, b); // 求幂运算
	mod(10, 1); // 模数（取余）
	fract(1.5); // 返回小数部分 1.5
	dot(normalize(NORMAL), normalize(VIEW)); // 点乘
	distance(COLOR.rgb, COLOR.rgb); // 向量间距
	smoothstep(0, 2, 1); // 插值,返回 0.5
	abs(-1); // 绝对值
	length(vec2(1)); // 矢量长度
	EMISSION; // 发光
	ALBEDO; // 漫射
	ALPHA; // 透明度
	METALLIC = 0.2; //设置金属度
	ROUGHNESS = 0.9; //设置粗糙度


	if(FRAGCOORD.x > FRAGCOORD.x){
		ALPHA = 0.0;
		}
}
 
## 编写规范
【类名】【枚举】使用【大驼峰命名】ClassName
【函数】【变量】使用【蛇形命名】set_func
【节点名称】使用【大驼峰命名】NewNode
【文件名称】使用【蛇形命名】new_script
【##】编写文档使用
【#】普通注释，用于函数内部
【通用方法】:复用且无关类型的写在全局
【分组】：只使用全局分组
集中配置加载项集中写
## 项目设置
[display]window/size/always_on_top=truewindow/stretch/mode="canvas_items"window/stretch/aspect="expand"[debug]gdscript/warnings/untyped_declaration=1[input_devices]pointing/emulate_touch_from_mouse=true
## 编辑器设置
text_editor/behavior/files/auto_reload_scripts_on_external_change = trueinterface/editor/code_font_contextual_ligatures = 2network/http_proxy/host = "127.0.0.1"network/http_proxy/port = 7897


## 编程思想
优先使用组合，组合大于继承。遵循solid原则，功能实现优先、效率优化第二考虑
