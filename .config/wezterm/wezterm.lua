local wezterm = require("wezterm")

return {
	term = "wezterm",
	color_scheme = "Kanagawa (Gogh)",
	font = wezterm.font("Hack Nerd Font Mono"),
	font_size = 12.3,
	enable_tab_bar = false,
	force_reverse_video_cursor = true,
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	max_fps = 250,
	allow_square_glyphs_to_overflow_width = "Never",
  use_ime = true,
}
