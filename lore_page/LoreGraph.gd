extends MarginContainer
onready var LGP = preload("res://lore_page/LoreGraphPoint.tscn")
onready var graph_box = $"%GraphBox"


var clans = {
	"iki_g_clan":{
		"rek": {"top": 100, "left": 0.5, "right": 0.5, "binds": ["kuroe", "wei"]},
		"kuroe": {"top": 200, "left": 0.2, "right": 0.2, "binds": ["saree"]},
		"wei": {"top": 200, "left": 0.8, "right": 0.8, "binds": ["krisma"]},
		"kaito": {"top": 500, "left": 0.5, "right": 0.5, "binds": ["kuroe", "wei", "krisma", "saree", "rek", "zatcy"]},
		"krisma": {"top": 800, "left": 0.65, "right": 0.65, "binds": ["saree"]},
		"saree": {"top": 800, "left": 0.35, "right": 0.35, "binds": []},
		"zatcy": {"top": 1100, "left": 0.5, "right": 0.5, "binds": []},
		},
	"aeon_strata_clan":{
		"syeei": {"top": 350, "left": 0.65, "right": 0.65, "binds": ["x_san"]},
		"x_san": {"top": 350, "left": 0.35, "right": 0.35},
	}
}

var points = {}
var curr_clan
var lines = []

func load_clan(clan):
	if clans.has(clan):
		for i in clans[clan]:
			var lgp = LGP.instance()
			graph_box.add_child(lgp)
			lgp.init_as(i, clan, clans[clan][i])
			points[i] = lgp
			curr_clan = clan
			print(clan)
	draw()

func _process(_delta):
	for i in lines:
		var mat = i.get("material")
		if mat and mat is ShaderMaterial:
			mat.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
			mat.set_shader_param("screen_size", get_viewport_rect().size)
#			print(mat.get_shader_param("mouse_pos"))

func draw():
	for i in points:
		if clans[curr_clan][i].has("binds"):
			for bind in clans[curr_clan][i]["binds"]:
				var line = Line2D.new()
				line.width = 2
				line.default_color = Color("a18162")
				line.points = [get_center(points[i]), get_center(points[bind])]
				line.set("texture", load("res://lore_page/iki_g_clan/clan_tree/line.png"))
				line.set_texture_mode(Line2D.LINE_TEXTURE_STRETCH)
#				line.set("material", load("res://main_page/GoldMaterialLine.tres"))
				add_child(line)
				lines.append(line)
#				draw_line(get_center(points[i]), get_center(points[bind]), Color.goldenrod, 20)

func get_center(node):
	return node.rect_position + Vector2(node.rect_size.x / 2.0, node.rect_size.y / 2.0)
