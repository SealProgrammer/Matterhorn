extends Control

@onready var mhi : MatterhornInternet = %MatterhornInternetMain

"""
Fuck you GameBanana API!
(it *fucking* sucks)

I need to first search, get every ID, instanciate a new instance of a mod, give it the id, and then have it do its own search to get the data. This is stupid. // edit: skipping this because I don't want to DOS them

Also, sometimes they just don't send data if it's zero! What the fuck. Fuck you.

You can tell I'm quite pissed off at Gamebanana.
"""


func _ready() -> void:
	mhi.search_gb_mods("dash", mhi.SORT_TYPES.POPULAR, 1, on_loaded)

func on_loaded(_result: int, _response_code: int, _headers: Array, body: PackedByteArray) -> void:
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	var response : Dictionary = json.get_data()
	
	# print(response)
	
	var data : Dictionary = mhi.fix_gbapi_prefix(response)

	# print(response)
	for mod: Dictionary in data["Records"]:
		# print(mod)
		var mod_data : Dictionary = {
			name = mod["Name"],
			author = mod["Submitter"]["Name"],
			uploaded = Time.get_date_string_from_unix_time(mod["DateAdded"]),
			edited = Time.get_date_string_from_unix_time(mod["DateModified"]),
			likes = mod.get("LikeCount", 0), # Because *of course* it doesn't always give back a value 🙄
			views = mod.get("ViewCount", 0)
		}
		
		print(mod_data)
