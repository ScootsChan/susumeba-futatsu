extends PanelContainer


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_button_up() -> void:
	get_tree().quit()
