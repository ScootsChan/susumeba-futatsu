extends Button
signal target_chosen

var assigned_target: Character
var attack: Attack

func _on_button_up() -> void:
	target_chosen.emit(assigned_target, attack)
	queue_free()
