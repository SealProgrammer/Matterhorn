extends VBoxContainer

signal new_selection(path: String)

var instance_node : Resource = preload("res://Scenes/Instance.tscn")


func populate_installs_list() -> void:
	for child in get_children():
		remove_child(child)
	
	for instance : Dictionary in MatterhornFileIO.get_user_data()["Instances"]:
		var new_instance : PanelContainer = instance_node.instantiate()
		
		new_instance.data = instance
		
		new_instance.selected.connect(select_new)
		
		add_child(new_instance)

func select_new(instance : PanelContainer, data : Dictionary) -> void:
	for child in get_children():
		child.set_theme_type_variation("PanelContainer")

	instance.set_theme_type_variation("PanelContainerSelected")
	
	emit_signal("new_selection", data)
