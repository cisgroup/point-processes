extends Button



func _on_button_up() -> void:
	# performe the reset function in the current TileMap 
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.grid_view()

