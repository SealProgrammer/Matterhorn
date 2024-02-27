extends PanelContainer

# This script is essentially just making it easier to set values.

var mod_name : String:
	set(x):
		%Name.text = x
	get:
		return %Name.text

var mod_version : String:
	set(x):
		%Version.text = x
	get:
		return %Version.text

var mod_author : String:
	set(x):
		%Author.text = x
	get:
		return %Author.text

var mod_description : String:
	set(x):
		%Description.text = x
	get:
		return %Description.text
