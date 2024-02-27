class_name MatterhornFileIO extends RefCounted

## Returns an array of dicts, representing the mods in the Fuji directory passed in.
static func get_mods(directory: String) -> Array:
	var mods : Array = []
	var dir : DirAccess = DirAccess.open("%s/mods" % directory)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				# If we're here, a mod has been found.
				var json = JSON.new()
				
				var err : Error = json.parse(FileAccess.get_file_as_string("%s/mods/%s/Fuji.json" % [directory, file_name]))
				
				if err == OK:
					var data = json.data
					mods.append(data)
				else:
					print("JSON Parse Error: ", json.get_error_message(), " in file ", directory, "/mods/", file_name, " at line ", json.get_error_line())
			
			file_name = dir.get_next()
	else:
		print("ERROR while opening directory!")
		print_debug(error_string(DirAccess.get_open_error()))
	return mods
