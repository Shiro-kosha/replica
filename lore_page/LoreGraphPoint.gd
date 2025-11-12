extends Control
onready var lore_graph_point = $"%LoreGraphPoint"
onready var frame = $"%Frame"

signal info_load_request

func _process(_delta):
	var mat = frame.get("material")
	if mat and mat is ShaderMaterial:
		mat.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
		mat.set_shader_param("screen_size", get_viewport_rect().size)

func init_as(character, clan, params):
	lore_graph_point.texture_normal = load(str("res://lore_page/", clan, "/clan_tree/", character, ".png"))
	self.anchor_left = float(params.left)
	self.anchor_right = float(params.right)
	self.margin_top = float(params.top)


func _on_LGPBtn_pressed():
	emit_signal("info_load_request")
