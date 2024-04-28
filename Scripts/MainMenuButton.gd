@tool extends PanelContainer

@export var label: String = "Press Me!":
	get:
		return %Text.text
	set(val):
		%Text.text = val

signal selected

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == 1:
			emit_signal("selected")
