## The class for all things internet-related in Matterhorn (ie, github and gamebanana stuff)
class_name MatterhornInternet extends Node

# I hate the Gamebanana API. I can't figure out how to get search results on api.gamebanana.com but I can't get a download link on gamebanana.com/apiv11. ahhhhhhhhhhhhhhhhhhhhhhhhh
# I decided to use both of them. Maybe you can send in a PR to fix this if you know how.

var http_request : HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)

## Helper function to get data from a URL. Requires an instance of MatterhornInternet to work (for garbage collection in this case)
func request(url: String, callback_on_completed: Callable) -> void:
	# First delete the node, then create a new one in it's place.
	# Fixes an error where the callback could be attatched twice to the same thing.
	# This _does_ mean that you probably can't request >1 thing at a time, but the docs say not to do that anyway, so it's probably ok.
	get_child(0).queue_free()
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request_completed.connect(callback_on_completed)
	
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

## A shortcut to get the FujiAPI/Fuji release.
func get_fuji_release_url(callback_on_fuji_url_found: Callable):
	request("https://api.github.com/repos/FujiAPI/Fuji/releases/latest", callback_on_fuji_url_found)
