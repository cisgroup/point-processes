extends Camera2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_WHEEL_UP:
			if zoom > Vector2(0.75,0.75):
				zoom -= Vector2(0.05,0.05)
		elif event.button_index==BUTTON_WHEEL_DOWN:
			if zoom < Vector2(4.0,4.0):
				zoom += Vector2(0.05,0.05)
