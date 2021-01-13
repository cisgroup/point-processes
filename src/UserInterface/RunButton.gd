extends Button

# When button is released action will be activated 
func _on_button_up() -> void:
	
	# performe the run function in the current TileMap 
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.run()
