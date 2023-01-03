
// Origin:
// https://gist.github.com/metaphore/b4750be45289109b3d49c97b5c300db6

surf = noone;
render_scale = 4;

application_surface_draw_enable(false);
gpu_set_tex_filter(false);

scale_factors		= [1, 2, 4];
scale_factor_index	= 0;
scale_factor		= scale_factors[scale_factor_index];