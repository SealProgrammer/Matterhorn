extends PanelContainer


func open() -> void:
	%StopInput.visible = true
	visible = true

func close() -> void:
	%StopInput.visible = false
	visible = false

## CHANGE THIS LATER!!
func _on_install_path_text_changed(new_text: String) -> void:
	var exists: bool = DirAccess.dir_exists_absolute(new_text)
	%BadPathImport.visible = !exists
	%ImportConfirm.disabled = exists
