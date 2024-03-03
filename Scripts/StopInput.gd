extends Panel

signal close_attempted

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("close_attempted")
