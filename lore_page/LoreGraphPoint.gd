extends TextureButton


func init_as(character, clan, params):
	self.texture_normal = load(str("res://lore_page/", clan, "/clan_tree/", character, "_c_frame.png"))
	self.anchor_left = params.left
	self.anchor_right = params.right
	self.anchor_top = params.top
