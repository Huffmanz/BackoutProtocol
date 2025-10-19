//Shader by: Jordancjb (https://linktr.ee/jordancjb)
//Licensed under Creative Commons 0, Use as you like c:
shader_type canvas_item;

//Noise Texture
uniform sampler2D Noise;

//Settings
uniform float Transparency = 4.0;
uniform float Slow = 25.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//render_mode light_only;

//Shader Code
void fragment() {
	vec4 c = COLOR;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * texture(Noise, texture(Noise, UV).xy + cos(TIME) / Slow) / Transparency;
	COLOR.a = c.a ;
	COLOR += c * vec4(.1,.10,.10,0);
}