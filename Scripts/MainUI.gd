extends Control

@onready var mhi : MatterhornInternet = %MatterhornInternet
var allowing_close : bool = true

var splashes : Array = []

"""
This class is the main script for the main menu; it deals with
various things throughout the main ui. It is ~90% signal handling.
This class will also deal with miscellanious things, such as
holding loaded trivia, etc.
"""

## Stuff to do at the begginning. I was writing docstrings for everything else and this felt out of place w/o one.
func _ready() -> void:
	%Instances.populate_installs_list()
	
	# Now we get the splashes; probably a good idea to store these.
	splashes = MatterhornFileIO.get_splashes()

## Called when a new install is requested.
func new_install() -> void:
	close_popups()
	%PleaseWait.open()
	allowing_close = false

	mhi.get_fuji_release_url(self._on_fuji_url_found)

## Callback for when we get back a Fuji url, while downloading the newest version.
func _on_fuji_url_found(_result: int, _response_code: int, _headers: Array, body: PackedByteArray) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response : Dictionary = json.get_data()
	
	print(response["url"])
	
	# Hopefully they don't change the conventions for this again. 0.6 went from "Windows" to "win" among others.
	var config : Dictionary = MatterhornFileIO.get_user_data()
	var os : String = config["OS"]
	var architecture : String = config["Architecture"]
	
	
	var file_name : String = "Celeste64-Fuji-%s-%s.zip" % [os, architecture]
	
	print(file_name)
	
	for asset : Dictionary in response["assets"]:
		if asset["name"] == file_name:
			print("Downloading Fuji!")
			mhi.request(asset["browser_download_url"], self._on_fuji_release_downloaded)
			return
	
	print("There was not a file available from GitHub.")
	print(response["assets"])
	assert(false) # Temporary until I fix it.
	
	# mhi.request(response["url"], self._on_fuji_release_downloaded)

## Callback for when a request to download the latest Fuji zip file has returned.
func _on_fuji_release_downloaded(_result: int, _response_code: int, _headers: Array, body: PackedByteArray) -> void:
	print("We are doing stuff! Downloaded Fuji, now installing...")
	
	var path : String = "%s/%s" % [%NewInstanceLocation.text, MatterhornHelpers.prepare_filename(%InstallName.text)]
	
	var file : FileAccess = FileAccess.open(path + ".zip", FileAccess.WRITE)
	file.store_buffer(body)
	
	# This seems like a good idea and should hopefully fix a bug.
	file.close()
	
	# Now unzip it.
	MatterhornFileIO.unzip(path + ".zip")
	
	# Now we need to update:
	# First, we update the config file:
	var config : Dictionary = MatterhornFileIO.get_user_data()
	config["Instances"].append({
		"Name": %InstallName.text,
		"Path": path,
		"Special": []
	})
	
	
	MatterhornFileIO.write_user_data(config)
	
	# Next, we need to update various nodes:
	# I would give this the config as a parameter but I couldn't get it to work. Send in a PR if you want.
	%Instances.populate_installs_list()
	
	%PleaseWait.close()
	allowing_close = true

func close_popups() -> void:
	if allowing_close:
		for child in get_children():
			if "Popups" in child.get_groups():
				child.visible = false


func _on_new_install_requested() -> void:
	%StopInput.visible = true
	%InstallFujiPopup.visible = true

func _on_import_install_requested() -> void:
	%StopInput.visible = true
	%ImportFujiPopup.visible = true

func _edit_instance() -> void:
	pass

func _on_refresh_splash_timeout() -> void:
	var new : Dictionary = splashes.pick_random()
	%SplashHeader.text = new["Header"]
	%SplashBody.text = new["Body"]

## Called when a new instance is selected.
func _on_instances_new_selection(data: Dictionary) -> void:
	# TODO: update Play button to work and stuff
	if data["Special"].has("Global"):
		pass
	else:
		pass
