extends MarginContainer

onready var image = $"%Image"

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
