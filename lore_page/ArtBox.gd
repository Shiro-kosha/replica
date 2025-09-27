extends MarginContainer

onready var main = get_tree().get_root().get_node("Main")
#
#onready var arts = [
#	preload("res://lore_page/art_1.png"),
#	preload("res://lore_page/art_2.png"), 
#	preload("res://lore_page/art_3.png")
#	]
#
#onready var art_names = [
#	preload("res://lore_page/ai_sisters.png"),
#	preload("res://lore_page/iki_g.png"),
#	preload("res://lore_page/aeon_strata.png"),
#]

onready var clans = [
	{"name": "ai_sisters", "art": preload("res://lore_page/art_1.png"), "art_name": preload("res://lore_page/ai_sisters.png")},
	{"name": "iki_g", "art": preload("res://lore_page/art_2.png"), "art_name": preload("res://lore_page/iki_g.png")},
	{"name": "aeon_strata", "art": preload("res://lore_page/art_3.png"), "art_name": preload("res://lore_page/aeon_strata.png")},
]


onready var BigIcon = preload("res://lore_page/BigIcon.tscn")

onready var art_box = $"%ArtBox"

func _ready():
	for clan in clans:
		var big_icon = BigIcon.instance()
		art_box.add_child(big_icon)
		big_icon.init_as(clan)
		big_icon.connect("lore_graph_load_request", main , "_on_lore_graph_load_request")



