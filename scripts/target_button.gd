extends Button
signal target_chosen

var assigned_target: Character
var attack: Attack
var attacker: CharacterData

func _on_button_up() -> void:
	target_chosen.emit(assigned_target, attack, attacker)
	queue_free()
