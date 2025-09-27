extends MarginContainer
onready var LGP = preload("res://lore_page/LoreGraphPoint.tscn")
onready var graph_box = $"%GraphBox"


var clans = {
	"iki_g_clan":{
		"rek": {"top": 0, "left": 0.5, "right": 0.5},
		"kuroe": {"top": 0.1, "left": 0.2, "right": 0.2},
		"wei": {"top": 0.1, "left": 0.8, "right": 0.8},
		"some": {"top": 0.5, "left": 0.5, "right": 0.5},
		"krisma": {"top": 0.7, "left": 0.65, "right": 0.65},
		"saree": {"top": 0.7, "left": 0.35, "right": 0.35},
		},
			
}

#func _ready():
#	load_clan("iki_g_clan")

func load_clan(clan):
	if clans.has(clan):
		for i in clans[clan]:
			var lgp = LGP.instance()
			graph_box.add_child(lgp)
			lgp.init_as(i, clan, clans.iki_g_clan[i])

