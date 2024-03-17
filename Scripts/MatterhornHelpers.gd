class_name MatterhornHelpers extends RefCounted

## Prepares a string to be used in a filename, stripping of any bad chars and changing spaces to -.
static func prepare_filename(str: String) -> String:
	var allowed: String = "qwertyuiopasdfghjklzxcvbnm1234567890-_"
	var toreturn: String = ""

	for char_index in len(str.dedent()):
		var char: String = str[char_index]
		if char==" ": char = "-"
		if allowed.findn(char) != -1:
			toreturn += char
	
	if toreturn == "":
		return "unnamed"
	
	return toreturn
