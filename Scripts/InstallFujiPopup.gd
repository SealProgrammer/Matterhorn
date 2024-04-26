extends PanelContainer

func open() -> void:
	%StopInput.visible = true
	visible = true

func close() -> void:
	%StopInput.visible = false
	visible = false

func _on_path_opener_dir_selected(dir: String) -> void:
	%InstallConfirm.disabled = false
	%NewInstanceLocation.text = dir
