extends Control


func _ready():
	# This whole thing feels haphazard but I couldn't find a better way to do it.
	var window : Window = get_window()
	var screen : int = window.current_screen

	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var base_window_size = Vector2(1100, 600)

	var scale_factor = screen_rect.size.x / 1920.0
	var new_window_size = base_window_size * scale_factor

	# Set the new window size
	DisplayServer.window_set_min_size(Vector2i(base_window_size))
	DisplayServer.window_set_size(Vector2i(new_window_size))
	center_window()
	
	# Setup the stuff
	MatterhornFileIO.write_new_config_if_not_exists()
	print(MatterhornFileIO.get_user_data())


func center_window() -> void:
	var window = get_window()
	var screen_rect = DisplayServer.screen_get_usable_rect(window.current_screen)

	window.position = screen_rect.position + (screen_rect.size - window.get_size_with_decorations()) / 2

func new_install() -> void:
	var install_name = %InstallName.text
	var install_path = %InstallPath.text # .get_basename().get_base_dir()
	
	var mhi = MatterhornInternet.new()
	
	mhi.get_c64_download_url()
	
	# Keep this at the end so that the user knows what's happening.
	close_popups()
	

func close_popups():
	for child in get_children():
		if "Popups" in child.get_groups():
			child.visible = false
