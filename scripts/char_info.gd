extends Window
@onready var hp_bar: ProgressBar = $CharContainer/MainVBox/TitleHBox/HPBar
@onready var speed_label: Label = $CharContainer/MainVBox/StatHBox/SpeedPanel/SpeedLabel
@onready var weakness_label: Label = $CharContainer/MainVBox/StatHBox/WeaknessPanel/WeaknessLabel
@onready var attack_hbox: HBoxContainer = $CharContainer/MainVBox/AttackHBox
@onready var main_vbox: VBoxContainer = $CharContainer/MainVBox
@onready var act_check: CheckBox = $CharContainer/MainVBox/StatHBox/ActPanel/ActHBox/ActCheck
@onready var declare_button: Button = $CharContainer/MainVBox/DeclarePanel/DeclareButton
@onready var sprite: TextureRect = $CharContainer/MainVBox/TitleHBox/Sprite


const TEST_CHAR = preload("res://data/characters/test_char.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_data(TEST_CHAR)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_data(data: CharacterData):
	self.title = data.char_name
	hp_bar.value = data.health
	hp_bar.max_value = data.max_health
	sprite.texture = data.sprite
	speed_label.text = "Speed: "+str(data.speed)
	weakness_label.text = "Weaknesses: "+data.weakness
	if data.acted == true:
		act_check.button_pressed = true
		act_check.disabled = true
		declare_button.disabled = true
	else:
		act_check.button_pressed = false
		act_check.disabled = false
		declare_button.disabled = false
		
	for n in data.attacks.size():
		var new_attack_box = attack_hbox.duplicate()
		main_vbox.add_child(new_attack_box)
		new_attack_box.visible = true
		
		var new_attack_icon = new_attack_box.get_node("AttackIcon")
		new_attack_icon.texture.region = Main.damage_icons[data.attacks[n].damage_type]
		
		var new_dmg_type = new_attack_box.get_node("DMGTypePanel/DamageType")
		new_dmg_type.text = data.attacks[n].damage_type.capitalize()
		
		var new_attack_name_label = new_attack_box.get_node("AttackNameLabel")
		new_attack_name_label.text = data.attacks[n].attack_name
		
		var new_range_label = new_attack_box.get_node("RangePanel/RangeLabel")
		new_range_label.text = "Range: "+str(data.attacks[n].range)
		
		var new_damage_label = new_attack_box.get_node("DamagePanel/DamageLabel")
		new_damage_label.text = "Damage: "+str(data.attacks[n].damage)
	attack_hbox.queue_free()


func _on_close_requested() -> void:
	queue_free()
