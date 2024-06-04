## The class for all things internet-related in Matterhorn (ie, github and gamebanana stuff)
class_name MatterhornInternet extends Node

# I hate the Gamebanana API. I can't figure out how to get search results on api.gamebanana.com but I can't get a download link on gamebanana.com/apiv11. ahhhhhhhhhhhhhhhhhhhhhhhhh
# I decided to use both of them. Maybe you can send in a PR to fix this if you know how.

var http_request : HTTPRequest

const SORT_TYPES = {
	BEST_MATCH = "best_match",
	POPULAR = "popularity",
	NEWEST = "date",
	UPDATED = "udate"
}

func _ready() -> void:
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
	
	var error := http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

## A shortcut to get the FujiAPI/Fuji release.
func get_fuji_release_url(callback_on_fuji_url_found: Callable) -> void:
	request("https://api.github.com/repos/FujiAPI/Fuji/releases/latest", callback_on_fuji_url_found)

## Removes the stupid prefix from gamebanana.com/api. Fuck you Hungary.
@warning_ignore("untyped_declaration")
func fix_gbapi_prefix(data):
	# I decided to scrape off the prefix for each parameter for better compatibility with api.gamebanana.com.
	if data is Dictionary:
		var modified_dict := {}
		#for key, value in data.items():
		for key in data.keys():
			var new_key = key.substr(3) if key.begins_with("_id") else key.substr(2)

			for character_i in range(len(key)):
				var character : String = key[character_i]
				if character == character.to_upper() and character != "_":
					new_key = key.trim_prefix(key.left(character_i)) # Why not `new_key = key[character_i:]`? No idea why GDScript doesn't have this. Pissed off by it.
					break
			
			var value = data[key]
			
			if value is Dictionary or value is Array:
				value = fix_gbapi_prefix(value)

			modified_dict[new_key] = value
			
		return modified_dict

	elif data is Array:
		var modified_list := []
		
		
		for index in range(len(data)):
			#print(index)
			var value = data[index]
			if value is Dictionary or value is Array:
				value = fix_gbapi_prefix(value)

			modified_list.append(value)

		return modified_list

## A function to search for mods from GameBanana.
func search_gb_mods(query: String, sort: String, page: int, callback: Callable) -> void:
	get_child(0).queue_free()
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request("https://gamebanana.com/apiv11/Util/Search/Results?_sSearchString=%s&_idGameRow=19773&_sModelName=Mod&_nPage=%s&_sOrder=%s" % [
		query,
		page,
		sort
	])
	
	http_request.request_completed.connect(callback)
