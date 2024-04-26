@tool extends PanelContainer

@export var label: String = "Press Me!":
	get:
		return $MarginContainer/Text.text
	set(val):
		$MarginContainer/Text.text = val

signal selected

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == 1:
			emit_signal("selected")
