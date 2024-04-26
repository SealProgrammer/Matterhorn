extends GridContainer

var mod_node : Resource = preload("res://Scenes/Mod.tscn")

func populate_modlist(directory: String) -> void:
	for child in get_children():
		remove_child(child)
	
	for mod : Dictionary in MatterhornFileIO.get_mods(directory):
		var new_mod : PanelContainer = mod_node.instantiate()
		
		new_mod.mod_name = mod["Name"]
		new_mod.mod_version = mod["Version"]
		new_mod.mod_author = mod["ModAuthor"]
		new_mod.mod_description = mod["Description"]

		add_child(new_mod)


func _on_new_instance_selection(data: Dictionary) -> void:
	populate_modlist(data["Path"])
