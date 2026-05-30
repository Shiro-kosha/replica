extends MarginContainer
onready var LGP = preload("res://lore_page/LoreGraphPoint.tscn")
onready var graph_box = $"%GraphBox"
onready var scroll_container = $"%ScrollContainer"
onready var info_box = $"%InfoBox"


onready var info_title_lbl = $"%InfoTitleLbl"
onready var philosophy_lbl = $"%PhilosophyLbl"
onready var structure_lbl = $"%StructureLbl"
onready var location_lbl = $"%LocationLbl"
onready var resources_lbl = $"%ResourcesLbl"
onready var ex_relation_lbl = $"%Ex_relationLbl"



onready var DB = Data.DB

var points = {}
var curr_clan
var lines = []
var clan_tree = {}


func load_clan(clan):
	print("LOADING CLAN: ", clan)
	clan_tree = {}
	for i in Data.DB.lore_graph.keys():
		if Data.DB.lore_graph[i]["clan"] == clan:
			clan_tree[i] = Data.DB.lore_graph[i]
	
	var scroll_size = 0
	for i in clan_tree.keys():
		var lgp = LGP.instance()
		graph_box.add_child(lgp)
		lgp.init_as(i, clan, clan_tree[i])
		lgp.connect("info_load_request", self, "load_info_page", [i])
		points[i] = lgp
		curr_clan = clan
		scroll_size = max(scroll_size, clan_tree[i]["top"] + 300)
		print(clan, i)
	graph_box.rect_min_size.y = scroll_size
	draw()
	yield(get_tree(), "idle_frame")
	_update_gold_panel_material(info_box)
	fill_info(clan)
	

func _process(_delta):
	for i in lines:
		var mat = i.get("material")
		if mat and mat is ShaderMaterial:
			mat.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
			mat.set_shader_param("screen_size", get_viewport_rect().size)
#			print(mat.get_shader_param("mouse_pos"))

func draw():
	for i in points.keys():
		if clan_tree[i].has("binds"):
			for bind in parse_json(clan_tree[i]["binds"]):
				if !points.has(bind):
					continue
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
	info_box.hide()
	var info_page = load("res://lore_page/InfoPage.tscn").instance()
	self.add_child(info_page)
	info_page.fill(char_id)

func fill_info(clan):
	var clan_info = DB.clans[clan]
	info_title_lbl.text = clan_info.name
#
	philosophy_lbl.bbcode_text = str(" ", clan_info.philosophy)
	structure_lbl.bbcode_text = str(" ", clan_info.structure)
	location_lbl.bbcode_text = str(" ", clan_info.location)
	resources_lbl.bbcode_text = str(" ", clan_info.resources)
	ex_relation_lbl.bbcode_text = str(" ", clan_info.ex_relation)
#
	
	

func _update_gold_panel_material(panel):
	var panel_size = panel.rect_size
	if panel_size == Vector2():
		panel_size = panel.rect_min_size
	panel.material.set_shader_param("panel_size", panel_size)
	panel.material.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
	panel.material.set_shader_param("screen_size", get_viewport_rect().size)
