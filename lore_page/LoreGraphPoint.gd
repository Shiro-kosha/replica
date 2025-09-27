extends Control
onready var lore_graph_point = $"%LoreGraphPoint"
onready var frame = $"%Frame"


func _process(_delta):
	var mat = frame.get("material")
	if mat and mat is ShaderMaterial:
		mat.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
		mat.set_shader_param("screen_size", get_viewport_rect().size)

func init_as(character, clan, params):
	lore_graph_point.texture_normal = load(str("res://lore_page/", clan, "/clan_tree/", character, "_c_frame.png"))
	self.anchor_left = params.left
	self.anchor_right = params.right
	self.margin_top = params.top
