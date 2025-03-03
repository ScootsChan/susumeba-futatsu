extends Sprite2D
@export var char_data: CharacterData

const TEST_CHAR = preload("res://data/characters/test_char.tres")

@onready var name_label: Label = $CharControl/CharVBox/NameLabel
@onready var allegiance_label: Label = $CharControl/CharVBox/AllegianceLabel
@onready var char_vbox: VBoxContainer = $CharControl/CharVBox
@onready var hp_bar: ProgressBar = $CharControl/CharVBox/HPBar


@onready var select_texture: Sprite2D = $SelectionTexture
@onready var cast: ShapeCast2D = $CharacterBody/Cast
@onready var char_body: CharacterBody2D = $CharacterBody

var hovered = false
var selected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hovered:
		char_vbox.visible = true
	else:
		char_vbox.visible = false
	if selected:
		select_texture.visible = true
	else:
		select_texture.visible = false
	
	hp_bar.value = char_data.health
	hp_bar.max_value = char_data.max_health
	
	
func load_char():
	if char_data == null:
		char_data = TEST_CHAR
	name_label.text = char_data.char_name
	allegiance_label.text = char_data.allegiance
	hp_bar.value = char_data.health
	hp_bar.max_value = char_data.max_health

func load_data(data: CharacterData):
	char_data = data

func dmg_calc(enemy_data: CharacterData):
	for n in char_data.attacks.size():
		if char_data.attacks[n].in_range:
			if enemy_data.weakness == char_data.attacks[n].damage_type:
				enemy_data.health -= char_data.attacks[n].damage*2
			else:
				enemy_data.health -= char_data.attacks[n].damage
			char_data.attacks[n].in_range = false

func auto_turn():
	if char_data.acted == false:
		attack()

func attack():
	for n in char_data.attacks.size():
		cast.shape.radius = char_data.attacks[n].range*Main.HEX_DISTANCE
		if cast.is_colliding():
			for x in cast.collision_result.size():
				if cast.collision_result[x].char_data.allegiance != char_data.allegiance:
					for y in char_data.attacks.size():
						if char_body.position.distance_to(cast.collision_result[x])>=char_data.attacks[y].range*Main.HEX_DISTANCE:
							char_data.attacks[y].in_range = true
					dmg_calc(cast.collision_result[x].char_data)
					break
				elif cast.collision_result[x].char_data.allegiance == char_data.allegiance:
					print(str(self)+" SPOTTED SAMEFOR!: "+cast.collision_result[x].to_string())

func _on_character_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("click"):
		print(self.to_string()+" CLICKED!")
		select()

func _on_character_body_mouse_entered() -> void:
	hovered = true

func _on_character_body_mouse_exited() -> void:
	hovered = false

func select():
	if selected: selected = false
	else: selected = true
