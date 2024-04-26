extends Panel

signal close_attempted

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("close_attempted")
