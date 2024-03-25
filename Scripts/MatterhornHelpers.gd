class_name MatterhornHelpers extends RefCounted

## Prepares a string to be used in a filename, stripping of any bad chars and changing spaces to -.
static func prepare_filename(text: String) -> String:
	var allowed: String = "qwertyuiopasdfghjklzxcvbnm1234567890-_"
	var toreturn: String = ""

	for char_index in len(text.dedent()):
		var character: String = text[char_index]
		if character==" ": character = "-"
		if allowed.findn(character) != -1:
			toreturn += character
	
	if toreturn == "":
		return "unnamed"
	
	return toreturn
