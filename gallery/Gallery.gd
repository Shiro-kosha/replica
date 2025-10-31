extends MarginContainer

var DB

onready var col_left = $"%ColLeft"
onready var col_mid = $"%ColMid"
onready var col_right = $"%ColRight"
onready var col_right_2 = $"%ColRight2"

onready var ZoomImg = preload("res://gallery/ZoomImg.tscn")

const T_DIR = "res://gallery/arts/"

onready var col_num = {
	1: col_left,
	2: col_mid,
	3: col_right,
	4: col_right_2
}


#var TEXTURE = {}
var zoom_inst
var pics_list = {}
var zoomed_pic_id

func _ready():
	pass
	DB = load_db()
#	report(DB)
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
	line = line.replace("path=\"", "").replace("\"", "")
	
	return ResourceLoader.load(line)


func fill():
	report("Filling...")
	for i in DB.gallery.keys():
		var path = str("res://gallery/arts/", i, ".jpg")
#		if dir.file_exists(path):
		var img = iload(path)
		var img_size = img.get_size()
		var TR = TextureButton.new()
		var col = col_num[int(DB.gallery[i].column)]
#		if img_size.x > img_size.y:
#			col = col_mid
#		else:
#			col = get_childless_col([col_left, col_right, col_right_2])
			
		TR.set("texture_normal", img)
		TR.set("expand", true)
		TR.connect("pressed", self, "add_zoom", [i])
		TR.rect_min_size.y = get_y(col.rect_size.x, img_size)
		col.add_child(TR)
		yield(get_tree().create_timer(0.1), "timeout")
		pics_list[i] = img

func get_y(x, img_size):
	return  (img_size.y * x) / img_size.x 

#func get_childless_col(colls_arr):
#	var childless = col_left
#	for i in colls_arr:
#		if childless.get_child_count() > i.get_child_count():
#			childless = i
#	return childless 

func report(_st):
	pass
#	$Label.text = str($Label.text, "\n\n", _st)

func add_zoom(id):
	zoom_inst = ZoomImg.instance()
	var wrap = CanvasLayer.new()
	wrap.add_child(zoom_inst)
	zoom_inst.connect("tree_exited", wrap, "queue_free")
	self.add_child(wrap)
	zoom_inst.set_image(pics_list[id])
	zoom_inst.connect("pic_changed", self, "zoom_next_pic")
	zoomed_pic_id = id

func zoom_next_pic(order):
	var keys = pics_list.keys()
	var curr_index = keys.find(zoomed_pic_id)
	if curr_index == -1:
		return # на всякий случай, если картинка не найдена
	
	var new_index = (curr_index + order) % keys.size()
	if new_index < 0:
		new_index += keys.size()  # чтобы не было отрицательных индексов
	
	var new_key = keys[new_index]
	zoom_inst.set_image(pics_list[new_key])
	zoomed_pic_id = new_key
