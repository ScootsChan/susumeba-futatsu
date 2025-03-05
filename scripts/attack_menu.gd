extends PanelContainer
@onready var sprite: TextureRect = $AttackVBox/TitleHBox/Sprite
@onready var char_label: Label = $AttackVBox/TitleHBox/CharLabel
@onready var attack_vbox: VBoxContainer = $AttackVBox
@onready var attack_margin: MarginContainer = $AttackVBox/AttackMargin

var loaded_attacks: Array[Attack]
signal attack_requested

func load_data(char_data: CharacterData):
	sprite.texture = char_data.sprite
	char_label.text = char_data.char_name
	for n in char_data.attacks.size():
		var new_attack_box = attack_margin.duplicate()
		attack_vbox.add_child(new_attack_box)
		new_attack_box.visible = true
		
		var new_attack_icon = new_attack_box.get_node("AttackHBox/AttackIcon")
		new_attack_icon.texture.region = Main.damage_icons[char_data.attacks[n].damage_type]
		
		var new_dmg_type = new_attack_box.get_node("AttackHBox/DMGTypePanel/DamageType")
		new_dmg_type.text = char_data.attacks[n].damage_type.capitalize()
		
		var new_attack_name_label = new_attack_box.get_node("AttackHBox/AttackNameLabel")
		new_attack_name_label.text = char_data.attacks[n].attack_name
		
		var new_range_label = new_attack_box.get_node("AttackHBox/RangePanel/RangeLabel")
		new_range_label.text = "Range: "+str(char_data.attacks[n].range)
		
		var new_damage_label = new_attack_box.get_node("AttackHBox/DamagePanel/DamageLabel")
		new_damage_label.text = "Damage: "+str(char_data.attacks[n].damage)
		
		var attack_button = new_attack_box.get_node("Button")
		attack_button.button_up.connect(attack_info.bind(char_data.attacks[n]))
	attack_margin.visible = false

func all_attacks():
	return loaded_attacks

func attack_info(attack: Attack):
	attack_requested.emit(attack)
	queue_free()
	#print("TATAKAE!")
