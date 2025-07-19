shader_type canvas_item;

uniform vec2 motion = vec2(0.0);
uniform float scale = 1.0;
uniform vec2 offset = vec2(0.0);

uniform sampler2D screen_texture : hint_screen_texture;

void vertex(){
	UV = (VERTEX + offset + TIME * motion) * TEXTURE_PIXEL_SIZE * (1.0/scale);
}