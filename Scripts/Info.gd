## A singleton for storing data captured during the onboarding process.
extends Node

var os : String = "Windows"
var architecture : String = "x64"

func _ready():
	var data : Dictionary = MatterhornFileIO.get_user_data()
	os = data["OS"]
	architecture = data["Architecture"]
