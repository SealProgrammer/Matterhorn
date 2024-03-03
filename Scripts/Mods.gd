extends GridContainer

var mod_node : Resource = preload("res://Scenes/Mod.tscn")

func populate_modlist(directory: String) -> void:
	for i in get_children():
		remove_child(i)
	
	for i in MatterhornFileIO.get_mods(directory):
		var new_mod = mod_node.instantiate()
		
		new_mod.mod_name = i["Name"]
		new_mod.mod_version = i["Version"]
		new_mod.mod_author = i["ModAuthor"]
		new_mod.mod_description = i["Description"]

		add_child(new_mod)


func _on_new_instance_selection(path):
	populate_modlist(path)
