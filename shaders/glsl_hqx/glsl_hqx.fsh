
// https://gist.github.com/metaphore/b4750be45289109b3d49c97b5c300db6

uniform sampler2D u_lut;
uniform vec2 u_textureSize;
uniform float u_fScale;

varying vec4 v_texCoord[4];

const vec3 YUV_THRESHOLD = vec3(48.0/255.0, 7.0/255.0, 6.0/255.0);
const vec3 YUV_OFFSET = vec3(0, 0.5, 0.5);

bool diff(vec3 yuv1, vec3 yuv2) {
    return any(greaterThan(abs((yuv1 + YUV_OFFSET) - (yuv2 + YUV_OFFSET)), YUV_THRESHOLD));
}

vec3 toYUV(vec3 color) {
	vec3 yuv = vec3(0.0);

	yuv.x = color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
	yuv.y = color.r * -0.169 + color.g * -0.331 + color.b * 0.5 + 0.5;
	yuv.z = color.r * 0.5 + color.g * -0.419 + color.b * -0.081 + 0.5;

	return yuv;
}

void main() {
    vec2 fp = fract(v_texCoord[0].xy * u_textureSize);
    vec2 quad = sign(-0.5 + fp);

    float dx = v_texCoord[0].z;
    float dy = v_texCoord[0].w;
    vec3 p1  = texture2D(gm_BaseTexture, v_texCoord[0].xy).rgb;
    vec3 p2  = texture2D(gm_BaseTexture, v_texCoord[0].xy + vec2(dx, dy) * quad).rgb;
    vec3 p3  = texture2D(gm_BaseTexture, v_texCoord[0].xy + vec2(dx, 0) * quad).rgb;
    vec3 p4  = texture2D(gm_BaseTexture, v_texCoord[0].xy + vec2(0, dy) * quad).rgb;
    // Use mat4 instead of mat4x3 here to support GLES.
    mat4 pixels = mat4(vec4(p1, 0.0), vec4(p2, 0.0), vec4(p3, 0.0), vec4(p4, 0.0));

    vec3 w1  = toYUV(texture2D(gm_BaseTexture, v_texCoord[1].xw).rgb);
    vec3 w2  = toYUV(texture2D(gm_BaseTexture, v_texCoord[1].yw).rgb);
    vec3 w3  = toYUV(texture2D(gm_BaseTexture, v_texCoord[1].zw).rgb);

    vec3 w4  = toYUV(texture2D(gm_BaseTexture, v_texCoord[2].xw).rgb);
    vec3 w5  = toYUV(p1);
    vec3 w6  = toYUV(texture2D(gm_BaseTexture, v_texCoord[2].zw).rgb);

    vec3 w7  = toYUV(texture2D(gm_BaseTexture, v_texCoord[3].xw).rgb);
    vec3 w8  = toYUV(texture2D(gm_BaseTexture, v_texCoord[3].yw).rgb);
    vec3 w9  = toYUV(texture2D(gm_BaseTexture, v_texCoord[3].zw).rgb);

    bvec3 pattern[3];
    pattern[0] =  bvec3(diff(w5, w1), diff(w5, w2), diff(w5, w3));
    pattern[1] =  bvec3(diff(w5, w4), false       , diff(w5, w6));
    pattern[2] =  bvec3(diff(w5, w7), diff(w5, w8), diff(w5, w9));
    bvec4 _cross = bvec4(diff(w4, w2), diff(w2, w6), diff(w8, w4), diff(w6, w8));

    vec2 index;
    index.x = dot(vec3(pattern[0]), vec3(1, 2, 4)) + dot(vec3(pattern[1]), vec3(8, 0, 16)) + dot(vec3(pattern[2]), vec3(32, 64, 128));
    index.y = dot(vec4(_cross), vec4(1, 2, 4, 8)) * (u_fScale * u_fScale) + dot(floor(fp * u_fScale), vec2(1.0, u_fScale));

    vec2 _step = vec2(1.0) / vec2(256.0, 16.0 * (u_fScale * u_fScale));
    vec2 offset = _step / vec2(2.0);
    vec4 weights = texture2D(u_lut, index * _step + offset);
    float sum = dot(weights, vec4(1));
    vec3 res = (pixels * (weights / sum)).rgb;

    gl_FragColor.rgb = res;
    // gl_FragColor.rgb = texture2D(gm_BaseTexture, fp).rgb;
    // gl_FragColor.rgb = vec3(float(pattern[1].x), float(pattern[1].x), float(pattern[1].x));
    // gl_FragColor.rgb = vec3(float(_cross.x), float(_cross.x), float(_cross.x));
    // gl_FragColor.rgb = vec3(index.y, index.y, index.y);
    // gl_FragColor.rgb = texture2D(gm_BaseTexture, v_texCoord[1].xw).rgb;
    // gl_FragColor.rgb = vec3(w2);//texture2D(gm_BaseTexture, v_texCoord[1].xw).rgb;
    gl_FragColor.a = 1.0;
}