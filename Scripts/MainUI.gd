extends Control

@onready var mhi = %MatterhornInternet

"""
This class is the main script for the project; it deals with
various things, from installing new instances of Fuji to messing
around with the window's size. This class is ~90% signal handling.
"""

func _ready():
	# This whole thing feels haphazard but I couldn't find a better way to do it.
	var window : Window = get_window()
	var screen : int = window.current_screen

	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var base_window_size = Vector2(1100, 600)

	var scale_factor = screen_rect.size.x / 1920.0
	var new_window_size = base_window_size * scale_factor
	
	
	
	# Set the new window size
	DisplayServer.window_set_min_size(Vector2i(base_window_size))
	DisplayServer.window_set_size(Vector2i(new_window_size))
	center_window()
	
	# Setup the stuff
	MatterhornFileIO.write_new_config_if_not_exists()
	
	%Instances.populate_installs_list()


func center_window() -> void:
	var window = get_window()
	var screen_rect = DisplayServer.screen_get_usable_rect(window.current_screen)

	window.position = screen_rect.position + (screen_rect.size - window.get_size_with_decorations()) / 2

func new_install() -> void:
	mhi.get_fuji_release_url(self._on_fuji_url_found)

## Callback for when we get back a Fuji url, while downloading the newest version.
func _on_fuji_url_found(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	print(response["url"])
	
	var os = "Windows"
	var architecture = "x64"
	match %OperatingSystem.get_selected_id():
		1:
			os = "Linux"
		2:
			os = "macOS"
		_:
			os = "Windows" # If they selected something else somehow, just default to Windows because it has the most likely chance of being correct.
	match %Architecture.get_selected_id():
		1:
			architecture = "arm"
		_:
			architecture = "x64"
	
	
	var file_name = "Celeste64-Fuji-%s-%s.zip" % [os, architecture]
	
	print(file_name)
	
	for asset in response["assets"]:
		if asset["name"] == file_name:
			print("Downloading Fuji!")
			mhi.request(asset["browser_download_url"], self._on_fuji_release_downloaded)

	# mhi.request(response["url"], self._on_fuji_release_downloaded)

	close_popups()

## Callback for when a request to download the latest Fuji zip file has returned.
func _on_fuji_release_downloaded(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	print("We are doing stuff! Downloaded Fuji, now installing...")
	
	var path : String = "%s/%s" % [%InstallPath.text, MatterhornHelpers.prepare_filename(%InstallName.text)]
	
	var file : FileAccess = FileAccess.open(path + ".zip", FileAccess.WRITE)
	file.store_buffer(body)
	
	# This seems like a good idea and should hopefully fix a bug.
	file.close()
	
	# Now unzip it.
	MatterhornFileIO.unzip(path + ".zip")
	
	# Now we need to update:
	# First, we update the config file:
	var config = MatterhornFileIO.get_user_data()
	config["Instances"].append({
		"Name": %InstallName.text,
		"Path": path
	})
	
	
	MatterhornFileIO.write_user_data(config)
	
	# Next, we need to update various nodes:
	# I would give this the config as a parameter but I couldn't get it to work. Send in a PR if you want.
	%Instances.populate_installs_list()

func close_popups() -> void:
	for child in get_children():
		if "Popups" in child.get_groups():
			child.visible = false


func _on_new_install_requested():
	%StopInput.visible = true
	%InstallFujiPopup.visible = true

func _edit_instance():
	pass # Replace with function body.
