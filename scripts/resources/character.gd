extends Sprite2D
class_name Character
@export var char_data: CharacterData

const TEST_CHAR = preload("res://data/characters/test_char.tres")
const MOVE_BUTTON = preload("res://scenes/move_button.tscn")

@onready var name_label: Label = $CharControl/CharVBox/NameLabel
@onready var allegiance_label: Label = $CharControl/CharVBox/AllegianceLabel
@onready var char_vbox: VBoxContainer = $CharControl/CharVBox
@onready var hp_bar: ProgressBar = $CharControl/CharVBox/HPBar

@onready var target_texture: AnimatedSprite2D = $TargetTexture
@onready var select_texture: Sprite2D = $SelectionTexture
@onready var cast: ShapeCast2D = $CharacterBody/Cast
@onready var char_body: Area2D = $CharacterBody

var hovered = false
var selected = false
var targeted = false
signal actionable_select
signal moved
signal target_found

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hovered and char_data.health > 0:
		char_vbox.visible = true
	else:
		char_vbox.visible = false
	
	if selected and char_data.allegiance == "BLUFOR":
		select_texture.visible = true
	elif selected:
		target_texture.visible = true
		targeted = true
	else:
		select_texture.visible = false
		target_texture.visible = false
		targeted = false
	
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

func take_damage(attack: Attack):
	if char_data.weakness == attack.damage_type:
		char_data.health -= attack.damage*2
	else:
		char_data.health -= attack.damage
	if char_data.health <= 0:
		die()

func auto_turn():
	if char_data.acted == false:
		auto_attack()

func auto_attack():
	for n in char_data.attacks.size():
		cast.shape.radius = char_data.attacks[n].range*Main.HEX_DISTANCE
		if cast.is_colliding():
			for x in cast.collision_result.size():
				if cast.collision_result[x]["collider"].get_parent().char_data.allegiance != char_data.allegiance and cast.collision_result[x]["collider"].char_data.health > 0:
					for y in char_data.attacks.size():
						if char_body.position.distance_to(cast.collision_result[x])>=char_data.attacks[y].range*Main.HEX_DISTANCE:
							char_data.attacks[y].in_range = true
					dmg_calc(cast.collision_result[x].char_data)
					if cast.collision_result[x].char_data.health <= 0:
						cast.collision_result[x].die()
					break
				elif cast.collision_result[x].char_data.allegiance == char_data.allegiance:
					print(str(self)+" SPOTTED SAMEFOR!: "+cast.collision_result[x].to_string())
		else:
			print("no targets found for "+str(self))

func die():
	rotation = 70
	

func _on_character_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("click"):
		print(self.to_string()+" CLICKED!")
		select()

func _on_character_body_mouse_entered() -> void:
	hovered = true
	#print("mousey entered! "+str(self)+" at "+str(get_global_mouse_position()))

func _on_character_body_mouse_exited() -> void:
	hovered = false
	#print("mousey exited! "+str(self)+" at "+str(get_global_mouse_position()))

func select():
	if selected: selected = false
	else: selected = true
	
	if Main.turn == "player" and char_data.acted == false:
		actionable_select.emit(self)
		print("ayo there's an actionable select done by "+str(self)+"!!")

func ordered_movement(target: Vector2i):
	self.position = target
	emit_signal("moved")

func find_targets(attack: Attack):
	var range = attack.range
	cast.shape.radius = range*Main.HEX_DISTANCE*2
	print(str(self)+" is looking for targets...")
	await get_tree().process_frame
	if cast.is_colliding():
		for x in cast.collision_result.size():
			var collider = cast.collision_result[x]["collider"].get_parent()
			if collider is Character:
				print("available target for "+str(self)+": "+str(cast.collision_result[x]))
				if collider.char_data.allegiance != self.char_data.allegiance and collider.char_data.health > 0:
					target_found.emit(collider, attack)
					char_data.acted = true
				elif collider.char_data.allegiance == char_data.allegiance:
					print(str(self)+" SPOTTED FRIENDLY: "+str(collider))
