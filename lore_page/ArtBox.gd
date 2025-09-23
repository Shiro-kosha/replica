extends MarginContainer

onready var arts = [
	preload("res://lore_page/art_1.png"),
	preload("res://lore_page/art_2.png"), 
	preload("res://lore_page/art_3.png")
	]

onready var art_names = [
	preload("res://lore_page/aeon_strata.png"),
	preload("res://lore_page/ai_sisters.png"),
	preload("res://lore_page/iki_g.png")
]

onready var BigIcon = preload("res://lore_page/BigIcon.tscn")

onready var art_box = $"%ArtBox"

func _ready():
	for art in range(arts.size()):
		var big_icon = BigIcon.instance()
		art_box.add_child(big_icon)
		big_icon.init_as(arts[art], art_names[art])
#		big_icon.icon_img.set("texture", arts[art])
#		big_icon.icon_name.set("texture", art_names[art])



