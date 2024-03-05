## The class for all things internet-related in Matterhorn (ie, github and gamebanana stuff)
class_name MatterhornInternet extends Node

# I hate the Gamebanana API. I can't figure out how to get search results on api.gamebanana.com but I can't get a download link on gamebanana.com/apiv11. ahhhhhhhhhhhhhhhhhhhhhhhhh
# I decided to use both of them. Maybe you can send in a PR to fix this if you know how.


## Helper function to get internet stuff.
static func get_website(base_url : String, directory: String, headers: Array = ["User-Agent: Pirulo/1.0 (Godot)","Accept: */*"]) -> String:
	# AKA: Stuff I copied from docs.godotengine.org/en/stable/tutorials/networking/http_client_class.html#doc-http-client-class
	# Why not just use a HTTPRequest node? Didn't want to fuck around with signals. Send in a pr if you want it fixed.

	var err = 0
	var http = HTTPClient.new() # Create the Client.

	err = http.connect_to_host(base_url, -1) # Connect to host/port.
	assert(err == OK) # Make sure connection is OK.

	# Wait until resolved and connected.
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting...")
		OS.delay_msec(250)

	assert(http.get_status() == HTTPClient.STATUS_CONNECTED) # Check if the connection was made successfully.

	err = http.request(HTTPClient.METHOD_GET, directory, headers) # Request a page from the site (this one was chunked..)
	assert(err == OK) # Make sure all is OK.

	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		# Keep polling for as long as the request is being processed.
		http.poll()
		print("Requesting...")
		OS.delay_msec(250)

	assert(http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED) # Make sure request finished well.

	# print("response? ", http.has_response()) # Site might not have a response.
	
	if http.has_response():
		var rb = PackedByteArray() # Array that will hold the data.

		while http.get_status() == HTTPClient.STATUS_BODY:
			# While there is body left to be read
			http.poll()
			# Get a chunk.
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				OS.delay_msec(250)
			else:
				rb = rb + chunk # Append to read buffer.
		
		# print("bytes got: ", rb.size())
		var text = rb.get_string_from_ascii()
		# print("Text: ", text)
		
		return text
	
	else:
		print("We didn't get anything back, tragic. !:3")
	#endregion
	return ""

## Fetches the download url for Celeste64-{platform}-x64.zip from the latest release of FujiAPI/Fuji Github repo.
static func get_c64_download_url(platform : String = "Windows") -> String:
	return JSON.parse_string(get_website("https://api.github.com", "/repos/FujiAPI/Fuji/releases/latest"))["url"]
