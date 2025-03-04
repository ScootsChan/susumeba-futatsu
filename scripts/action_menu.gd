extends PanelContainer
@onready var sprite: TextureRect = $ActionsVBox/CharStuffHBox/Sprite
@onready var char_label: Label = $ActionsVBox/CharStuffHBox/CharLabel
@onready var movement_button: Button = $ActionsVBox/MovementButton


signal movement_requested

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
	#for n in char.attacks.size():

func _on_movement_button_button_up() -> void:
	movement_requested.emit(char)
	#print(str(char))
	#movement_button.disabled = true
