shader_type canvas_item;

uniform vec2 pos;
uniform vec2 screenSize;
uniform float circleSize;
//uniform bool active;

void fragment () {
	vec2 screenPos = vec2(SCREEN_UV.x * screenSize.x, (SCREEN_UV.y * screenSize.y * -1.0f) + screenSize.y);
	float posDist = distance(pos, screenPos);
	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);
	if (posDist < circleSize) {
		COLOR = bg;
	} else {
		float avg = (bg.r + bg.g + bg.b) / 3.0f;
		COLOR = vec4(avg, avg, avg, 1.0f);
	}
}