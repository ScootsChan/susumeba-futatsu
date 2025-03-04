extends Button
signal move_here

func _on_button_up() -> void:
	emit_signal("move_here")
	queue_free()
