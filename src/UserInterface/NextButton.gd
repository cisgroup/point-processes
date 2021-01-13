extends Button



func _on_button_up() -> void:
	
	# performe the next function in the current TileMap 
	Global.current_scene.next()
