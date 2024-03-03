extends PanelContainer

signal download_requested(name : String, path : String)

func open() -> void:
	%StopInput.visible = true
	visible = true

func close() -> void:
	%StopInput.visible = false
	visible = false



func _on_install_path_text_changed(new_text):
	%BadPath.visible = !DirAccess.dir_exists_absolute(new_text)
