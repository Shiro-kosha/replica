extends Control

class_name Main
onready var dis_tw = $"%DisTW"

enum SECTIONS { MAIN, GALLERY, LORE, ABOUT}

onready var SCENES = {
	SECTIONS.MAIN : preload("res://main_page/ArtBox.tscn"),
	SECTIONS.GALLERY : preload("res://gallery/Gallery.tscn"),
#	SECTIONS.LORE : preload("res://main_page/ArtBox.tscn"),
#	SECTIONS.ABOUT : preload("res://main_page/ArtBox.tscn"),
	}
onready var spacer = $ScrollContainer/ContentBox/Spacer

onready var content_box = $"%ContentBox"
onready var tool_bar = $"%ToolBar"

var current_content = SECTIONS.MAIN

func _ready():
	for btn in tool_bar.btns.keys():
		btn.connect("pressed", self, "_on_content_request", [tool_bar.btns[btn]])
	
	load_to_mainbox(SECTIONS.MAIN)


func _on_content_request(content):
	if current_content == content:
		return
	current_content = content
	clear()
	load_to_mainbox(content)


func load_to_mainbox(content):
	if dis_tw.is_active():
		yield(dis_tw, "tween_all_completed")
	
	if SCENES.keys().has(content):
		var loaded_content = SCENES[content].instance()
		loaded_content.modulate.a = 0
		content_box.add_child(loaded_content)
		dis_tw.interpolate_property(loaded_content, "modulate:a", 0, 1, 0.2)
		dis_tw.start()

func clear():
	for i in content_box.get_children():
		if i != spacer:
			dis_tw.interpolate_property(i, "modulate:a", 1, 0, 0.2)
			dis_tw.connect("tween_all_completed", i, "queue_free")
	dis_tw.start()
	
#	i.queue_free()
