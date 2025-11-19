extends MarginContainer

signal content_load_request

enum SECTIONS { MAIN, GALLERY, LORE, ABOUT, LORE_GRAPH}

func _on_GalleryBtn_pressed():
	emit_signal("content_load_request", SECTIONS.GALLERY)


func _on_LoreBtn_pressed():
	emit_signal("content_load_request", SECTIONS.LORE)
