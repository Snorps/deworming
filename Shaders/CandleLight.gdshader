shader_type canvas_item;

uniform vec2 pos;
uniform vec2 screenSize;
uniform float circleSize;
uniform float bwRimSize;
//uniform bool active;

void fragment () {
	vec2 screenPos = vec2(SCREEN_UV.x * screenSize.x, (SCREEN_UV.y * screenSize.y * -1.0f) + screenSize.y);
	float posDist = distance(pos, screenPos);
	vec4 bg = textureLod(SCREEN_TEXTURE, SCREEN_UV, 1.0);
	float avg = (bg.r + bg.g + bg.b) / 3.0f;
	vec4 bw = vec4(avg, avg, avg, 1.0f);
	vec4 bwFade = mix(bg, bw, clamp(posDist / circleSize, 0.0, 1.0));
	COLOR = mix(bwFade, vec4(0.0,0.0,0.0,1.0), clamp((posDist + bwRimSize) / circleSize, 0.0, 1.0));
}