#version 320 es

precision highp float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform vec4 uBackground;
uniform vec4 uSmoke;

out vec4 fragColor;

float latticeHash(vec2 cell) {
  vec2 folded = fract(cell * vec2(0.1273, 0.3917));
  folded += dot(folded, folded.yx + vec2(19.19, 7.31));
  return fract((folded.x + folded.y) * folded.x * folded.y);
}

float smoothNoise(vec2 point) {
  vec2 cell = floor(point);
  vec2 local = fract(point);
  vec2 curve = local * local * (3.0 - 2.0 * local);

  float bottom = mix(
    latticeHash(cell),
    latticeHash(cell + vec2(1.0, 0.0)),
    curve.x
  );
  float top = mix(
    latticeHash(cell + vec2(0.0, 1.0)),
    latticeHash(cell + vec2(1.0, 1.0)),
    curve.x
  );
  return mix(bottom, top, curve.y);
}

float fluidNoise(vec2 point) {
  float value = 0.0;
  float weight = 0.57;
  mat2 turn = mat2(0.82, -0.57, 0.57, 0.82);

  for (int octave = 0; octave < 3; octave++) {
    value += smoothNoise(point) * weight;
    point = turn * point * 2.07 + vec2(1.73, -0.91);
    weight *= 0.48;
  }

  return value;
}

void main() {
  vec2 coordinate = FlutterFragCoord().xy;
  vec2 uv = coordinate / uSize;
  vec2 spherePoint = (coordinate - uSize * 0.5) * 2.0 / min(uSize.x, uSize.y);
  float radiusSquared = dot(spherePoint, spherePoint);
  float edgeSoftness = 2.0 / min(uSize.x, uSize.y);
  float orbMask = 1.0 - smoothstep(1.0 - edgeSoftness, 1.0 + edgeSoftness, sqrt(radiusSquared));

  float slowTime = uTime * 0.24;
  vec2 wideDrift = vec2(
    sin(slowTime * 0.83 + 0.41) + 0.47 * cos(slowTime * 1.61 + 2.37),
    cos(slowTime * 0.71 + 1.14) + 0.53 * sin(slowTime * 1.29 + 0.76)
  );
  vec2 crossDrift = vec2(
    cos(slowTime * 1.07 + 2.03),
    sin(slowTime * 0.93 + 2.71)
  );

  vec2 samplePoint = uv * vec2(1.62, 1.08) + wideDrift * 0.44;
  float warpX = fluidNoise(samplePoint + crossDrift * 0.37);
  float warpY = fluidNoise(samplePoint.yx * vec2(1.11, 0.89) - crossDrift * 0.42 + vec2(4.17, 2.64));
  vec2 warpedPoint = samplePoint + vec2(warpX - 0.5, warpY - 0.5) * 1.31;
  float body = fluidNoise(warpedPoint + wideDrift.yx * 0.21);
  float fine = smoothNoise(warpedPoint * 2.38 - crossDrift * 0.56);

  float rollingBoundary = uv.y + 0.11 * uv.x + (body - 0.5) * 0.46 + (fine - 0.5) * 0.11;
  float vapor = smoothstep(0.36, 0.78, rollingBoundary);
  float wisp = smoothstep(0.57, 0.88, body + fine * 0.24) * (1.0 - vapor) * 0.24;
  float smokeAmount = clamp(vapor + wisp, 0.0, 1.0);

  vec3 midpoint = mix(uBackground.rgb, uSmoke.rgb, 0.55);
  vec3 surface = mix(uBackground.rgb, midpoint, smoothstep(0.06, 0.62, smokeAmount));
  surface = mix(surface, uSmoke.rgb, smoothstep(0.58, 1.0, smokeAmount));
  float surfaceAlpha = mix(uBackground.a, uSmoke.a, smokeAmount);

  float normalZ = sqrt(max(0.0, 1.0 - radiusSquared));
  vec3 normal = normalize(vec3(spherePoint, normalZ));
  vec3 keyLight = normalize(vec3(-0.58, -0.66, 0.94));
  float diffuse = clamp(dot(normal, keyLight), 0.0, 1.0);
  float lowerRightShade = clamp((spherePoint.x + spherePoint.y) * 0.18, -0.12, 0.20);
  float rimShade = pow(1.0 - normalZ, 1.7) * 0.18;
  float lighting = 0.82 + diffuse * 0.22 - lowerRightShade - rimShade;
  float highlight = pow(diffuse, 10.0) * 0.12 * (1.0 - smokeAmount * 0.45);
  vec3 litSurface = clamp(surface * lighting + vec3(highlight), 0.0, 1.0);

  float alpha = surfaceAlpha * orbMask;
  fragColor = vec4(litSurface * alpha, alpha);
}
