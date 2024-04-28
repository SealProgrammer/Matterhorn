extends PanelContainer

signal selected(object: PanelContainer, data: Dictionary)

var data : Dictionary:
	set(val):
		%Name.text = val["Name"]
		# This feels wrong. All I wanted was italics but I had to write everything else out too.
		%Path.text = "[outline_color=black][outline_size=2][i][color=aaaaaa][font_size=12]%s[/font_size][/color][/i][/outline_size][/outline_color]" % val["Path"]
		data = val

var cur_selected : bool = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == 1:
			emit_signal("selected", self, data)
