extends MarginContainer

onready var hidden_bnts = [$"%KofiBtn", $"%YoutubeBtn", $"%DiscBtn"]
onready var open_btn = $"%OpenBtn"
onready var btn_box = $"%BtnBox"
onready var btn_container = $"%BtnContainer"
onready var inv_box = $"%InvBox"
onready var btns = [$"%OpenBtn", $"%KofiBtn", $"%YoutubeBtn", $"%DiscBtn", $"%PatronBtn", $"%InstBtn", $"%XBtn"]
onready var animation_player = $AnimationPlayer
onready var nine_patch_rect = $"%NinePatchRect"

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in btns:
		i.connect("mouse_entered", self, "glow", [i, true])
		i.connect("mouse_exited", self, "glow", [i, false])

func _on_OpenBtn_pressed():
	if !open:
		print("open")
		animation_player.play("open_anim")
	else:
		print("close")
		animation_player.play("close")
	open = !open
#	open_btn.flip_h = !open_btn.flip_h
#	inv_box.visible = !inv_box.visible
#	for i in hidden_bnts:
#		i.visible = !i.visible
#

func glow(btn, entered):
	if entered:
		for i in ["r", "g", "b"]:
			btn.modulate[i] += 0.3
	else:
		for i in ["r", "g", "b"]:
			btn.modulate[i] -= 0.3

func _on_BtnContainer_mouse_entered():
	nine_patch_rect.modulate.a = 0.9


func _on_BtnContainer_mouse_exited():
	nine_patch_rect.modulate.a = 0.7
