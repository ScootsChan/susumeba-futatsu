extends PanelContainer
@onready var sprite: TextureRect = $ActionsVBox/CharStuffHBox/Sprite
@onready var char_label: Label = $ActionsVBox/CharStuffHBox/CharLabel

var char_data: CharacterData

func load_char(char: CharacterData):
	char_data = char
	
	sprite.texture = char_data.sprite
	char_label.text = char_data.char_name
	#for n in char.attacks.size():
