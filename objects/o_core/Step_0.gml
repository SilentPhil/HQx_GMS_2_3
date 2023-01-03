
if (keyboard_check_pressed(vk_space)) {
	scale_factor_index = ((scale_factor_index + 1) % array_length(scale_factors));
	scale_factor = scale_factors[scale_factor_index];
}