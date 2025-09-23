extends TextureRect

#const MARKED = Color(1.2,1.2,1.2,1)
#const UNMARKED = Color(1,1,1,1)
const UNMARKED = Color(0.7,0.7,0.7, 1)
const MARKED = Color(1,1,1,1)
onready var glow_tw = $"%GlowTw"
onready var frame = $"%Frame"


func _ready():
	self.set("modulate", UNMARKED)

func _process(_delta):
	var mat = frame.get("material")
	if mat and mat is ShaderMaterial:
		mat.set_shader_param("mouse_pos", get_viewport().get_mouse_position())
		mat.set_shader_param("screen_size", get_viewport_rect().size)

func _on_BigIcon_mouse_entered():
	glow(MARKED)


func _on_BigIcon_mouse_exited():
	glow(UNMARKED)

func glow(state):
	if glow_tw.is_active():
		glow_tw.stop_all()
	glow_tw.interpolate_property(self, "modulate", self.modulate, state, 0.2)
	glow_tw.start()
