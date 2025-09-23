extends VBoxContainer

#const MARKED = Color(1.2,1.2,1.2,1)
#const UNMARKED = Color(1,1,1,1)
const UNMARKED = Color(0.7,0.7,0.7, 1)
const MARKED = Color(1,1,1,1)
onready var glow_tw = $"%GlowTw"
onready var frame = $"%Frame"
onready var icon_name = $"%IconName"
onready var icon_img = $"%IconImg"



func _ready():
	self.set("modulate", UNMARKED)

func init_as(i_img, i_name):
	if !self.is_node_ready():
		yield(self, "ready")
	icon_img.texture = i_img
	icon_name.texture = i_name
	icon_name.rect_min_size.x = 250#get_x(icon_name.rect_min_size.y, i_name.get_size())
#	print(i_name.get_size(), get_x(icon_name.rect_min_size.y, i_name.get_size()))

func _process(_delta):
	var mat = frame.get("material")
	if mat and mat is ShaderMaterial:
		mat.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
		mat.set_shader_param("screen_size", get_viewport_rect().size)

func get_x(y, img_size):
	return  (img_size.x * y) / img_size.y 

func _on_BigIcon_mouse_entered():
	glow(MARKED)


func _on_BigIcon_mouse_exited():
	glow(UNMARKED)

func glow(state):
	if glow_tw.is_active():
		glow_tw.stop_all()
	glow_tw.interpolate_property(self, "modulate", self.modulate, state, 0.2)
	glow_tw.start()
