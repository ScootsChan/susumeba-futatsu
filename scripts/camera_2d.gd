extends Camera2D

func _input(event):
	if Input.is_action_pressed("scroll_up"):
		zoom.x = clamp(zoom.x+0.1, 0.8, 1.8)
		zoom.y = clamp(zoom.y+0.1, 0.8, 1.8)
	elif Input.is_action_pressed("scroll_down"):
		zoom.x = clamp(zoom.x-0.1, 0.8, 1.8)
		zoom.y = clamp(zoom.y-0.1, 0.8, 1.8)
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("pan"):
			position -= event.relative*zoom*0.5
