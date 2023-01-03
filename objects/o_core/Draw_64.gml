
if (!surface_exists(surf)) {
	surf = surface_create(surface_get_width(application_surface) * scale_factor, surface_get_height(application_surface) * scale_factor);
}
surface_set_target(surf);

if (scale_factor > 1) {
	shader_set(glsl_hqx);
	shader_set_uniform_f(shader_get_uniform(glsl_hqx, "u_textureSize"), surface_get_width(application_surface), surface_get_height(application_surface));
	shader_set_uniform_f(shader_get_uniform(glsl_hqx, "u_fScale"), scale_factor);
	texture_set_stage(shader_get_sampler_index(glsl_hqx, "u_lut"), sprite_get_texture(asset_get_index("s_hq" + string(scale_factor) + "x"), 0));

	draw_surface_ext(application_surface, 0, 0, scale_factor, scale_factor, 0, c_white, 1);

	shader_reset();
} else {
	draw_surface_ext(application_surface, 0, 0, scale_factor, scale_factor, 0, c_white, 1);
}

surface_reset_target();

draw_surface_ext(surf, 0, 0, render_scale / scale_factor, render_scale / scale_factor, 0, c_white, 1);

draw_set_color(c_black);
draw_rectangle(0, 10, 50, 30, false);

draw_set_color(c_white);
draw_text(10, 10, "HQ" + string(scale_factor) + "x");