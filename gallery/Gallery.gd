extends MarginContainer

var DB

onready var col_left = $"%ColLeft"
onready var col_mid = $"%ColMid"
onready var col_right = $"%ColRight"
onready var col_right_2 = $"%ColRight2"

const T_DIR = "res://gallery/arts/"
var TEXTURE = {}


func _ready():
	pass
	DB = load_db()
	report(DB)
	fill()

func load_db():
	var f = File.new()
	if f.file_exists("res://data/Replica.json"):
		var err = f.open("res://data/Replica.json", File.READ)
		if err != OK:
			report("Failed to open JSON file, code %s" % err)
			return {}
		var text = f.get_as_text()
		var parsed = JSON.parse(text)
		if parsed.error != OK:
			report("JSON parse error: %s (line %s)" % [parsed.error_string, parsed.error_line])
			return str("JSON parse error: %s (line %s)" % [parsed.error_string, parsed.error_line])
		return parsed.result
	else:
		report("no DataBase found!")
		return str("no DataBase found!")


func iload(path):
	var f = File.new()
	if f.open(str(path, ".import"), File.READ) != OK:
		report("Cannot open file: %s" % path)
		return null
	report("opening: %s" % path)
	var line = ""
	while not f.eof_reached():
		line = f.get_line()
		if line.begins_with("path"):
			break
#		else:
#			push_error("No 'path' found in file: %s" % path)
#			return null
	
	# Убираем path=" и " с конца
	line = line.replace("path=\"", "").replace("\"", "")
	
	return ResourceLoader.load(line)


func fill():
	report("Filling...")
	var dir = Directory.new()
	for i in DB.gallery.keys():
		var path = str("res://gallery/arts/", i, ".jpg")
#		if dir.file_exists(path):
		var img = iload(path)
		var img_size = img.get_size()
		var TR = TextureRect.new()
		var col = col_right
		if img_size.x > img_size.y:
			col = col_mid
		else:
			col = get_childless_col([col_left, col_right, col_right_2])
			
		TR.set("texture", img)
		TR.set("expand", true)
		var msy = (img_size.y * col.rect_size.x) / img_size.x 
		TR.rect_min_size.y = msy
		col.add_child(TR)
		yield(get_tree().create_timer(0.1), "timeout")

func get_childless_col(colls_arr):
	var childless = col_left
	for i in colls_arr:
		if childless.get_child_count() > i.get_child_count():
			childless = i
	return childless 

func report(st):
	pass
#	$Label.text = str($Label.text, "\n\n", st)
