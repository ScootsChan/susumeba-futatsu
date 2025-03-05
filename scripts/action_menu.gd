extends PanelContainer
@onready var sprite: TextureRect = $ActionsVBox/CharStuffHBox/Sprite
@onready var char_label: Label = $ActionsVBox/CharStuffHBox/CharLabel
@onready var movement_button: Button = $ActionsVBox/MovementButton
@onready var attacks_button: Button = $ActionsVBox/AttacksButton
@onready var end_turn: Button = $ActionsVBox/EndTurn
#const ATTACK_MENU = preload("res://scenes/attack_menu.tscn")

signal movement_requested
signal attack_requested

var char_data: CharacterData
var char: Character

func load_char(loaded_char: Character):
	char_data = loaded_char.char_data
	char = loaded_char
	
	sprite.texture = char_data.sprite
	char_label.text = char_data.char_name
	
	if char_data.moved:
		movement_button.disabled = true
	else:
		movement_button.disabled = false
	
	if char_data.acted:
		attacks_button.disabled = true
		end_turn.disabled = true
	else:
		attacks_button.disabled = false
		end_turn.disabled = false
		visible = true
	#for n in char.attacks.size():

func _on_movement_button_button_up() -> void:
	movement_requested.emit(char)
	#print(str(char))
	#movement_button.disabled = true

#func _on_attacks_button_button_up() -> void:
	#var attack_menu = ATTACK_MENU.instantiate()
	#add_child(attack_menu)
	#attack_menu.attack_requested.connect(pass_attack_info)
	#attack_requested.emit()

func pass_attack_info(attack: Attack):
	attack_requested.emit(attack)

func _on_end_turn_button_up() -> void:
	char_data.acted = true
	visible = false
