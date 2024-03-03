extends PanelContainer

signal selected(object: PanelContainer, path: String)

var instance_name : String = "Epic Fuji Installation  (•̀ ω •́ )b":
	set(val):
		%Name.text = val
		instance_name = val

var instance_path : String:
	set(val):
		%Path.text = "[i][color=727272][font_size=12]%s[/font_size][/color][/i]" % val
		instance_path = val

var cur_selected : bool = false

func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == 1:
			emit_signal("selected", self, instance_path)
			# set_theme_type_variation("PanelContainerSelected")
