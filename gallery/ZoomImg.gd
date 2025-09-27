extends MarginContainer

onready var image = $"%Image"
onready var close_btn = $"%CloseBtn"


const MARKED = Color(1.5, 1.5, 1.5, 1)
const UNMARKED = Color(1, 1, 1, 1)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_image(img):
	image.texture = img


func _on_CloseBtn_pressed():
	self.queue_free()

func _on_CloseBtn_mouse_entered():
	close_btn.set("modulate", MARKED)


func _on_CloseBtn_mouse_exited():
	close_btn.set("modulate", UNMARKED)
