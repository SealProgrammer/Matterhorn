extends Control

@export_file("*.tscn") var onboarding_node_path: String
@export_file("*.tscn") var main_node_path: String


func _ready() -> void:
	# This whole thing feels haphazard but I couldn't find a better way to do it.
	var window : Window = get_window()
	var screen : int = window.current_screen

	var screen_rect := DisplayServer.screen_get_usable_rect(screen)
	var base_window_size := Vector2(1100, 600)

	var scale_factor := screen_rect.size.x / 1920.0
	var new_window_size := base_window_size * scale_factor
	
	
	
	# Set the new window size
	DisplayServer.window_set_min_size(Vector2i(base_window_size))
	DisplayServer.window_set_size(Vector2i(new_window_size))
	center_window()
	
	var path: String = ""
	if MatterhornFileIO.config_exists():
		var main_node: Node = load(main_node_path).instantiate()
		add_child(main_node)
	else:
		var onboarding_node: Node = load(onboarding_node_path).instantiate()
		onboarding_node.connect("completed", restart)
		add_child(onboarding_node)


## Restarts the application.
func restart() -> void:
	get_tree().reload_current_scene()

## Centers... the window... what did you expect?
func center_window() -> void:
	var window := get_window()
	var screen_rect := DisplayServer.screen_get_usable_rect(window.current_screen)

	window.position = Vector2(screen_rect.position) + (screen_rect.size - window.get_size_with_decorations()) / 2.0
