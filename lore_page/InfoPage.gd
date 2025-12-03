extends MarginContainer

onready var name_lbl = $"%NameLbl"
onready var nickname_lbl = $"%NicknameLbl"
onready var age_lbl = $"%AgeLbl"
onready var race_lbl = $"%RaceLbl"
onready var role_lbl = $"%RoleLbl"
onready var modsbl = $"%Modsbl"
onready var avatar = $"%Avatar"

onready var DB = Data.DB

var page_char_id
var clan


onready var DEFAULTS = [
	{"lbl": name_lbl, "id": "name", "base": "Name: "},
	{"lbl": nickname_lbl, "id": "nickname", "base": "Nickname (s): "},
	{"lbl": age_lbl, "id": "age", "base": "Age: "},
	{"lbl": race_lbl, "id": "race_species", "base": "Race / Species: "},
	{"lbl": role_lbl, "id": "role_in_the_clan", "base": "Role in the clan: "},
	{"lbl": modsbl, "id": "modifications", "base": "Modifications:\n"},
#	{"lbl": name_lbl, "id": "name"}
]

func _ready():
	pass # Replace with function body.

func fill(char_id):
	page_char_id = char_id
	if DB.char.keys().has(char_id):
		for i in DEFAULTS:
			i.lbl.set("text", str(i.base, DB["char"][char_id].get(i.id, "No Data.")))
	else:
		printerr("NOT FOUND: ", char_id)
	clan = Data.DB.lore_graph[char_id].get("clan")
	if clan:
		avatar.set("texture", load(str("res://lore_page/", clan, "/inf_page/", char_id, ".png")))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GalleryBtn_pressed():
	Data.emit_signal("gallery_load_request", page_char_id)


func _on_BackBtn_pressed():
	Data.emit_signal("lore_graph_load_request", clan)
