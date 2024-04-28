extends Control

signal completed

## Called when the user submits the form.
func _on_submit_pressed() -> void:
	# Debug testing thing
	var pressed_button : CheckBox = %Archx64.get_button_group().get_pressed_button()
	if pressed_button:
		var arch : String = ""
		match pressed_button.text:
			"ARM":
				arch = "arm"
			_: # Effectively just `"x64":` but I felt like some basic error protection was good.
				arch = "x64"
		
		var os: String = MatterhornFileIO.get_os()
		
		# Has to be on its own or it errors.
		var global_loc : String = MatterhornFileIO.get_fuji_appdata_folder()
		
		var file : FileAccess = FileAccess.open("user://Matterhorn.json", FileAccess.WRITE)
		# Will probably add more to this file later.
		
		file.store_string(JSON.stringify({
			"OS": os,
			"Architecture": arch,
			"Version": Info.version,
			"Instances": [
				{
					"Name": "Global Installation",
					"Path": global_loc,
					"Special": [
						"Global"
					]
				}
			]
		}, "\t", false))
		
		emit_signal("completed")
