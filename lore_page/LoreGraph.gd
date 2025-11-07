extends MarginContainer
onready var LGP = preload("res://lore_page/LoreGraphPoint.tscn")
onready var graph_box = $"%GraphBox"
onready var scroll_container = $"%ScrollContainer"





var clans = {
	"iki_g_clan":{
		"rethink": {"top": 200, "left": 0.5, "right": 0.5, "binds": ["kuroe", "wei"]},
		"kuroe": {"top": 300, "left": 0.2, "right": 0.2, "binds": ["saree"]},
		"wei": {"top": 300, "left": 0.8, "right": 0.8, "binds": ["krisma"]},
		"kaito": {"top": 600, "left": 0.5, "right": 0.5, "binds": ["kuroe", "wei", "krisma", "saree", "rethink", "zatcy"]},
		"krisma": {"top": 900, "left": 0.65, "right": 0.65, "binds": ["saree"]},
		"saree": {"top": 900, "left": 0.35, "right": 0.35, "binds": []},
		"zatcy": {"top": 1200, "left": 0.5, "right": 0.5, "binds": []},
		},
	"aeon_strata_clan":{
		"syeei": {"top": 450, "left": 0.65, "right": 0.65, "binds": ["x_san"]},
		"x_san": {"top": 450, "left": 0.35, "right": 0.35},
	}
}

var points = {}
var curr_clan
var lines = []

func load_clan(clan):
	
	var scroll_size = 0
	if clans.has(clan):
		for i in clans[clan]:
			var lgp = LGP.instance()
			graph_box.add_child(lgp)
			lgp.init_as(i, clan, clans[clan][i])
			lgp.connect("info_load_request", self, "load_info_page", [i])
			points[i] = lgp
			curr_clan = clan
			scroll_size = max(scroll_size, clans[clan][i]["top"] + 300)
			print(clan, i)
	graph_box.rect_min_size.y = scroll_size
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
				graph_box.add_child(line)
				lines.append(line)
#				draw_line(get_center(points[i]), get_center(points[bind]), Color.goldenrod, 20)

func get_center(node):
	return node.rect_position + Vector2(node.rect_size.x / 2.0, node.rect_size.y / 2.0)

func load_info_page(char_id):
	scroll_container.hide()
	var info_page = load("res://lore_page/InfoPage.tscn").instance()
	self.add_child(info_page)
	info_page.fill(char_id)
#	print(char_id.to_upper())
