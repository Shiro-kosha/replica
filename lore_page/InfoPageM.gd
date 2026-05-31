extends MarginContainer

onready var name_lbl = $"%InfoNameLbl"
onready var nickname_lbl = $"%InfoNicknameLbl"
onready var age_lbl = $"%InfoAgeLbl"
onready var race_lbl = $"%InfoRaceLbl"
onready var role_lbl = $"%InfoRoleLbl"
onready var modsbl = $"%InfoModsLbl"
onready var info_title_lbl = $"%InfoTitleLbl"
onready var avatar = $"%Avatar"
#onready var main_portrait = $"HBoxContainer/MainPortrait"
onready var main_portrait = $"%MainPortrait"
onready var main_portrait_outline = $"%GoldOutline"

onready var category_box = $"%CategoryBox"
onready var category_title_lbl = $"%CategoryTitleLbl"
onready var category_lbl = $"%CategoryLbl"


onready var featured_scroll = $"%ScrollContainer"
onready var featured_list = $"%PreviewList"
onready var clan_grid = $"HBoxContainer/ClanBox/VBoxContainer/ScrollContainer/GridContainer"
onready var clan_nav_box = $"HBoxContainer/ClanBox/VBoxContainer/ClanNavBox"

onready var is_title_lbl = $"%ISTitleLbl"
onready var identity_semantics_lbl = $"%IdentitySemanticsLbl"


onready var DB = Data.DB

var page_char_id
var clan
var gold_panel_boxes = []
var featured_pics = {}
var featured_zoom_inst
var featured_zoomed_pic_id

const GALLERY_DIR = "res://gallery/arts/"
const PREVIEW_CORNER_RADIUS = 25.0
const DEFAULT_SCROLLBAR_WIDTH = 12.0
const CLAN_GRID_COLUMNS = 3
const CLAN_GRID_SEPARATION = 10.0
const CLAN_NAV_PREVIEW_SIZE = 50.0

onready var ZoomImg = preload("res://gallery/ZoomImg.tscn")
onready var RoundedPreviewMaterial = preload("res://lore_page/UI/RoundedPreviewMaterial.tres")
onready var CirclePreviewMaterial = preload("res://lore_page/UI/CirclePreviewMaterial.tres")
onready var CLANS = [
	{"id": "iki_g_clan", "icon": "res://lore_page/UI/clan_icon_iki_g_temp.png"},
	{"id": "aeon_strata_clan", "icon": "res://lore_page/UI/clan_icon_aeon_strata_temp.png"},
	{"id": "ai_sisters_clan", "icon": "res://lore_page/UI/clan_icon_ai_sisters_temp.png"}
]


onready var DEFAULTS = [
	{"lbl": name_lbl, "id": "name", "base": "Name: "},
	{"lbl": nickname_lbl, "id": "nickname", "base": "Nickname (s): "},
	{"lbl": age_lbl, "id": "age", "base": "Age: "},
	{"lbl": race_lbl, "id": "race_species", "base": "Race / Species: "},
	{"lbl": role_lbl, "id": "role_in_the_clan", "base": "Role in the clan: "},
	{"lbl": modsbl, "id": "modifications", "base": "Modifications:\n"},
#	{"lbl": name_lbl, "id": "name"}
]

onready var categories_list = {
		"concept_role": $"%ConceptBtn",
		"modifications": $"%ModBtn",
		"character": $"%CharBtn",
		"relationship": $"%RelationBtn",
		"trivia": $"%TriviaBtn"}

const CATEGORIES = {
		"concept_role": "Concept & Role",
		"modifications": "Physical Embodiment & Technology Integration",
		"character": "Character & Psychological Portrait",
		"relationship": "Social Connections & Dynamics",
		"trivia": "Trivia & Living Details"}
	

onready var main_btn = $"%MainBtn"

func _ready():
	if main_portrait.material:
		main_portrait.material = main_portrait.material.duplicate()
		_update_main_portrait_size()
	if main_portrait_outline.material:
		main_portrait_outline.material = main_portrait_outline.material.duplicate()
		_update_main_portrait_outline_size()
	_setup_gold_panel_boxes(self)
#	_fill_clan_nav_box()
	
	for i in categories_list:
		categories_list[i].connect("pressed", self, "_show_category", [i])
	main_btn.connect("pressed", self, "appear_anim", [[category_box], true])


func _process(_delta):
	if main_portrait_outline.material:
		main_portrait_outline.material.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
		main_portrait_outline.material.set_shader_param("screen_size", get_viewport_rect().size)
		_update_main_portrait_outline_size()
	for panel in gold_panel_boxes:
		_update_gold_panel_material(panel)


func _setup_gold_panel_boxes(node):
	if node is PanelContainer and node.material:
		node.material = node.material.duplicate()
		gold_panel_boxes.append(node)
		_update_gold_panel_material(node)
	for child in node.get_children():
		_setup_gold_panel_boxes(child)


func _update_main_portrait_size():
	if main_portrait.material:
		var target_size = main_portrait.rect_size
		if target_size == Vector2():
			target_size = main_portrait.rect_min_size
		main_portrait.material.set_shader_param("target_size", target_size)


func _update_main_portrait_outline_size():
	if main_portrait_outline.material:
		var target_size = main_portrait.rect_size
		if target_size == Vector2():
			target_size = main_portrait.rect_min_size
		main_portrait_outline.material.set_shader_param("target_size", target_size)


func _update_gold_panel_material(panel):
	var panel_size = panel.rect_size
	if panel_size == Vector2():
		panel_size = panel.rect_min_size
	panel.material.set_shader_param("panel_size", panel_size)
	panel.material.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
	panel.material.set_shader_param("screen_size", get_viewport_rect().size)


func _load_imported_texture(path):
	var import_file = File.new()
	if import_file.open(str(path, ".import"), File.READ) != OK:
		printerr("Cannot open imported texture: ", path)
		return null

	var imported_path = ""
	while not import_file.eof_reached():
		var line = import_file.get_line()
		if line.begins_with("path"):
			imported_path = line.replace("path=\"", "").replace("\"", "")
			break
	import_file.close()

	if imported_path == "":
		printerr("Cannot find imported texture path: ", path)
		return null
	return ResourceLoader.load(imported_path)


func _clear_featured_list():
	for child in featured_list.get_children():
		if child is TextureRect:
			featured_list.remove_child(child)
			child.queue_free()
	featured_pics = {}


func _get_featured_preview_size():
	var preview_size = featured_scroll.rect_size.x
	if preview_size <= 0.0:
		preview_size = $"HBoxContainer/FeaturedBox".rect_size.x - 32.0
	if preview_size <= 0.0:
		preview_size = featured_list.rect_min_size.x
	if preview_size <= 0.0:
		preview_size = 338.0

	var scrollbar_width = DEFAULT_SCROLLBAR_WIDTH
	var scrollbar = featured_scroll.get_v_scrollbar()
	if scrollbar:
		if scrollbar.rect_min_size.x > 0.0:
			scrollbar_width = scrollbar.rect_min_size.x
		elif scrollbar.rect_size.x > 0.0:
			scrollbar_width = scrollbar.rect_size.x

	return max(1.0, preview_size - scrollbar_width) - 10


func _fill_featured_list(char_id):
	_clear_featured_list()

	var preview_size = _get_featured_preview_size()
	featured_list.rect_min_size.x = preview_size

	for art_id in DB.gallery.keys():
		var tags = parse_json(DB.gallery[art_id].get("tags", "[]"))
		if not (tags is Array and tags.has(char_id)):
			continue

		var texture = _load_imported_texture(str(GALLERY_DIR, art_id, ".jpg"))
		if not texture:
			continue

		var preview_material = RoundedPreviewMaterial.duplicate()
		preview_material.set_shader_param("preview_size", Vector2(preview_size, preview_size))
		preview_material.set_shader_param("texture_size", texture.get_size())
		preview_material.set_shader_param("corner_radius", PREVIEW_CORNER_RADIUS)

		var preview = TextureRect.new()
		preview.material = preview_material
		preview.texture = texture
		preview.expand = true
		preview.stretch_mode = TextureRect.STRETCH_SCALE
		preview.rect_min_size = Vector2(preview_size, preview_size)
		preview.size_flags_horizontal = 0
		preview.mouse_filter = Control.MOUSE_FILTER_STOP
		preview.connect("gui_input", self, "_on_featured_preview_gui_input", [art_id])
		featured_list.add_child(preview)
		featured_pics[art_id] = texture


func _on_featured_preview_gui_input(event, art_id):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		_open_featured_zoom(art_id)


func _open_featured_zoom(art_id):
	if not featured_pics.has(art_id):
		return

	featured_zoom_inst = ZoomImg.instance()
	var wrap = CanvasLayer.new()
	wrap.add_child(featured_zoom_inst)
	featured_zoom_inst.connect("tree_exited", wrap, "queue_free")
	self.add_child(wrap)
	featured_zoom_inst.set_image(featured_pics[art_id])
	featured_zoom_inst.connect("pic_changed", self, "_zoom_next_featured_pic")
	featured_zoomed_pic_id = art_id


func _zoom_next_featured_pic(order):
	var keys = featured_pics.keys()
	var curr_index = keys.find(featured_zoomed_pic_id)
	if curr_index == -1 or keys.empty():
		return

	var new_index = (curr_index + order) % keys.size()
	if new_index < 0:
		new_index += keys.size()

	var new_key = keys[new_index]
	featured_zoom_inst.set_image(featured_pics[new_key])
	featured_zoomed_pic_id = new_key


func _clear_clan_grid():
	for child in clan_grid.get_children():
		clan_grid.remove_child(child)
		child.queue_free()


func _fill_clan_grid(curr_clan):
	_clear_clan_grid()
	var preview_size = clan_grid.rect_size.x
	if preview_size <= 0.0:
		preview_size = clan_grid.rect_min_size.x
	if preview_size <= 0.0:
		preview_size = $"HBoxContainer/ClanBox/VBoxContainer/ScrollContainer".rect_size.x
	if preview_size <= 0.0:
		preview_size = 328.0
	preview_size = (preview_size - (CLAN_GRID_COLUMNS - 1) * CLAN_GRID_SEPARATION) / CLAN_GRID_COLUMNS

	for character in DB.lore_graph.keys():
		if DB.lore_graph[character].get("clan") != curr_clan:
			continue

		var texture = load(str("res://lore_page/", curr_clan, "/clan_tree/", character, ".png"))
		if not texture:
			continue

		var preview = TextureRect.new()
		preview.material = CirclePreviewMaterial.duplicate()
		preview.texture = texture
		preview.expand = true
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		preview.rect_min_size = Vector2(preview_size, preview_size)
		preview.mouse_filter = Control.MOUSE_FILTER_STOP
		preview.connect("gui_input", self, "_on_clan_preview_gui_input", [character])
		clan_grid.add_child(preview)


func _on_clan_preview_gui_input(event, character):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		fill(character)


func _clear_clan_nav_box():
	for child in clan_nav_box.get_children():
		clan_nav_box.remove_child(child)
		child.queue_free()


func _fill_clan_nav_box():
	_clear_clan_nav_box()
	for clan_data in CLANS:
		var texture = load(clan_data.icon)
		if not texture:
			continue

		var preview = TextureRect.new()
		preview.material = CirclePreviewMaterial.duplicate()
		preview.texture = texture
		preview.expand = true
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		preview.rect_min_size = Vector2(CLAN_NAV_PREVIEW_SIZE, CLAN_NAV_PREVIEW_SIZE)
		preview.mouse_filter = Control.MOUSE_FILTER_STOP
		preview.connect("gui_input", self, "_on_clan_nav_gui_input", [clan_data.id])
		clan_nav_box.add_child(preview)


func _on_clan_nav_gui_input(event, clan_id):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		Data.emit_signal("lore_graph_load_request", clan_id)


func fill(char_id):
	page_char_id = char_id
	_fill_featured_list(char_id)
	if DB.char.keys().has(char_id):
		var char_data = DB["char"][char_id]
		info_title_lbl.text = char_data.get("name", char_data.get("nickname", char_id))
		for i in DEFAULTS:
			i.lbl.set("text", str(i.base, char_data.get(i.id, "No Data.")))
		
		var is_android = char_data.race_species == "Android"
		if is_android:
			is_title_lbl.text = "Etymology of Code"
		else:
			is_title_lbl.text = "Identity Semantics"
		
		identity_semantics_lbl.bbcode_text = char_data.identity_semantics
		
	else:
		info_title_lbl.text = char_id
		printerr("NOT FOUND: ", char_id)
	clan = Data.DB.lore_graph[char_id].get("clan")
	
	
	
	if clan:
		_fill_clan_grid(clan)
		var portrait_texture = load(str("res://lore_page/", clan, "/inf_page/", char_id, ".png"))
		if portrait_texture:
			avatar.set("texture", portrait_texture)
			if main_portrait.material:
				_update_main_portrait_size()
				_update_main_portrait_outline_size()
				main_portrait.material.set_shader_param("portrait_texture", portrait_texture)
				main_portrait.material.set_shader_param("portrait_size", portrait_texture.get_size())
	
	appear_anim([category_box], true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _categorybox_appear():
	category_box.modulate.a = 0
	category_box.visible = true
	var appearTW = Tween.new()
	self.add_child(appearTW)
	appearTW.connect("tween_all_completed", appearTW, "queue_free")
	appearTW.interpolate_property(category_box, "modulate:a", 0, 1, 0.3)
	appearTW.start()

func appear_anim(objects: Array, is_reversed = false):
	
	var appearTW = Tween.new()
	self.add_child(appearTW)
	appearTW.connect("tween_all_completed", appearTW, "queue_free")
	
	for i in objects:
		if is_reversed and (!i.visible or i.modulate.a == 0):
			continue
		i.visible = true
		appearTW.connect("tween_all_completed", i, "set", ["visible", !is_reversed])
#		i.modulate.a = float(!is_reversed)
		appearTW.interpolate_property(i, "modulate:a", float(is_reversed), float(!is_reversed), 0.5)
	appearTW.start()
	return appearTW
	

func _show_category(id):
	
	if !category_box.visible:
		category_title_lbl.text = CATEGORIES[id]
		category_lbl.bbcode_text = DB.char[page_char_id][id]
		appear_anim([category_box])
	else:
		var a = appear_anim([category_lbl, category_title_lbl], true)
		yield(a, "tween_all_completed")
		category_title_lbl.text = CATEGORIES[id]
		category_lbl.bbcode_text = DB.char[page_char_id][id]
		appear_anim([category_lbl, category_title_lbl], false)
		




func _on_GalleryBtn_pressed():
	Data.emit_signal("gallery_load_request", page_char_id)


func _on_BackBtn_pressed():
	Data.emit_signal("lore_graph_load_request", clan)
