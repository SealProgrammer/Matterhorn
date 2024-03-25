extends PanelContainer

func open() -> void:
	%StopInput.visible = true
	visible = true

func close() -> void:
	%StopInput.visible = false
	visible = false

func _on_install_path_text_changed(new_text):
	var exists : bool = DirAccess.dir_exists_absolute(new_text)
	%BadPathInstall.visible = !exists
	%InstallConfirm.disabled = exists
