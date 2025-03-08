extends HBoxContainer
@onready var unit_icon: TextureRect = $UnitIcon
@onready var unit_name: Label = $UnitName
@onready var hp: Label = $UnitHealthPanel/UnitHealth

func load_data(char_data: CharacterData):
	print(char_data.char_name+" is being loaded...")
	if char_data.health == 0: ###### if dead, pretty much
		unit_icon.texture = char_data.death_sprite
	else:
		unit_icon.texture = char_data.sprite
	unit_name.text = char_data.char_name
	hp.text = str(char_data.health)+" / "+str(char_data.max_health)
		
	print(hp.text)
