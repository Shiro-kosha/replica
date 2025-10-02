extends MarginContainer

onready var image = $"%Image"
onready var close_btn = $"%CloseBtn"

onready var rigth_arr_btn = $"%RigthArrBtn"
onready var left_arr_btn = $"%LeftArrBtn"

const MARKED = Color(1.5, 1.5, 1.5, 1)
const UNMARKED = Color(1, 1, 1, 1)

signal pic_changed(order)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in [close_btn, rigth_arr_btn, left_arr_btn]:
		i.connect("mouse_entered", self, "set_marked", [i])
		i.connect("mouse_exited", self, "set_unmarked", [i])
	
	rigth_arr_btn.connect("pressed", self, "change_pic", [1])
	left_arr_btn.connect("pressed", self, "change_pic", [-1])

func set_image(img):
	image.texture = img

func change_pic(order):
	emit_signal("pic_changed", order)

func _on_CloseBtn_pressed():
	self.queue_free()

func set_marked(node):
	node.set("modulate", MARKED)

func set_unmarked(node):
	node.set("modulate", UNMARKED)
