extends Node

onready var DB

func _ready():
	DB = load_db()


func load_db():
	var f = File.new()
	if f.file_exists("res://data/Replica.json"):
		var err = f.open("res://data/Replica.json", File.READ)
		if err != OK:
#			report("Failed to open JSON file, code %s" % err)
			return {}
		var text = f.get_as_text()
		var parsed = JSON.parse(text)
		if parsed.error != OK:
#			report("JSON parse error: %s (line %s)" % [parsed.error_string, parsed.error_line])
			return str("JSON parse error: %s (line %s)" % [parsed.error_string, parsed.error_line])
		return parsed.result
	else:
#		report("no DataBase found!")
		return str("no DataBase found!")
