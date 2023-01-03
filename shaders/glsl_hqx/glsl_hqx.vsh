attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_TextureCoord; // (u, v)

varying vec4 v_texCoord[4];

uniform vec2 u_textureSize;

void main() {
	vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

    vec2 ps = 1.0 / u_textureSize;
    float dx = ps.x;
    float dy = ps.y;
	
    //   +----+----+----+
    //   |    |    |    |
    //   | w1 | w2 | w3 |
    //   +----+----+----+
    //   |    |    |    |
    //   | w4 | w5 | w6 |
    //   +----+----+----+
    //   |    |    |    |
    //   | w7 | w8 | w9 |
    //   +----+----+----+

    v_texCoord[0].xy = in_TextureCoord.xy;
    v_texCoord[0].zw = ps;
    v_texCoord[1] = in_TextureCoord.xxxy + vec4(-dx, 0, dx, -dy); //  w1 | w2 | w3
    v_texCoord[2] = in_TextureCoord.xxxy + vec4(-dx, 0, dx,   0); //  w4 | w5 | w6
    v_texCoord[3] = in_TextureCoord.xxxy + vec4(-dx, 0, dx,  dy); //  w7 | w8 | w9
}