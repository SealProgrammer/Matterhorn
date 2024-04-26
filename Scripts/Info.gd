## A singleton for storing data captured during the onboarding process. It can be accessed in any file.
extends Node

var architecture : String = "x64"
## This is a number representing only the `Matterhorn.json` file's version; it may not represent the version on Github or something. It will be used for upgrading the file.
var version : int = 0

func _ready() -> void:
	var data : Dictionary = MatterhornFileIO.get_user_data()
	architecture = data["Architecture"]