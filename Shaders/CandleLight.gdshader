shader_type canvas_item;

uniform sampler2D vignetteTexture;
uniform vec2 pos = vec2(538, 286);
uniform vec2 screenSize;
uniform float circleInnerSize;
uniform float circleFadeSize;
uniform float circleFadeOuterSize;
uniform float circleDarknessSize;
uniform float bwRimSize;
uniform float time;
uniform float waveStrength;
uniform float waveSpeed;
//uniform bool active;

void fragment () {
	vec2 screenPos = vec2(SCREEN_UV.x * screenSize.x, (SCREEN_UV.y * screenSize.y * -1.0f) + screenSize.y);
	float posDist = distance(pos, screenPos);
	vec4 bg = textureLod(SCREEN_TEXTURE, SCREEN_UV, 1.0);
	vec2 vignetteUV = vec2(UV.x + (sin(UV.x * time * waveSpeed) * waveStrength), UV.y + (sin(UV.y * time * waveSpeed) * waveStrength));
	vec4 vignetteColor = texture(vignetteTexture, vignetteUV);
	vec4 vignette = mix(vec4(1.0,1.0,1.0,1.0), vignetteColor, clamp((posDist - circleInnerSize) / circleFadeSize, 0.0, 1.0));
	vec4 bgToVignette = vec4(bg.r * vignette.r, bg.g * vignette.g, bg.b * vignette.b, 1.0f);
	COLOR = mix(bgToVignette, vec4(0.0,0.0,0.0,1.0), clamp((posDist - circleFadeOuterSize) / circleDarknessSize, 0.0, 1.0));
	//vec4 bw = vec4(avg, avg, avg, 1.0f);
	//vec4 bwFade = mix(bg, bw, clamp(posDist / circleSize, 0.0, 1.0));
	//COLOR = mix(bwFade, vec4(0.0,0.0,0.0,1.0), clamp((posDist - bwRimSize) / circleSize, 0.0, 1.0));
}