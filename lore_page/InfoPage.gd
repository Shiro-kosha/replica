extends MarginContainer

onready var name_lbl = $"%NameLbl"
onready var nickname_lbl = $"%NicknameLbl"
onready var age_lbl = $"%AgeLbl"
onready var race_lbl = $"%RaceLbl"
onready var role_lbl = $"%RoleLbl"
onready var modsbl = $"%Modsbl"

onready var DB = Data.DB

onready var DEFAULTS = [
	{"lbl": name_lbl, "id": "name", "base": "Name: "},
	{"lbl": nickname_lbl, "id": "nickname", "base": "Nickname (s): "},
	{"lbl": age_lbl, "id": "age", "base": "Age: "},
	{"lbl": race_lbl, "id": "race_species", "base": "Race / Species: "},
	{"lbl": role_lbl, "id": "role_in_the_clan", "base": "Role in the clan:"},
	{"lbl": modsbl, "id": "modifications", "base": "Modifications:\n"},
#	{"lbl": name_lbl, "id": "name"}
]

func _ready():
	pass # Replace with function body.

func fill(char_id):
	if DB.char.keys().has(char_id):
		for i in DEFAULTS:
			i.lbl.set("text", str(i.base, DB["char"][char_id][i.id]))
	else:
		printerr("NOT FOUND: ", char_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
