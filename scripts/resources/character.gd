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

signal get_moving

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
	self.texture = char_data.sprite
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

func enemy_turn():
	match char_data.enemy_type: ####### Determining movement for the enemy
		"grunt":
			var target: Character
			for x in char_data.attacks.size():
				target = await enemy_find_targets(char_data.attacks[x])
			if target != null:
				get_moving.emit(self, target.position)
			else:
				get_moving.emit(self, self.position+Vector2(0,100))
	await char_data.moved == true
	auto_attack()
	char_data.acted = true

func auto_attack():
	for n in char_data.attacks.size():
		cast.shape.radius = (char_data.attacks[n].range+1)*Main.HEX_DISTANCE*1.25
		if cast.is_colliding():
			for x in cast.collision_result.size():
				var collider = cast.collision_result[x]["collider"].get_parent()
				if collider.char_data.allegiance != char_data.allegiance && collider.char_data.health > 0:
					for y in char_data.attacks.size():
						if char_body.position.distance_to(collider.position)>=char_data.attacks[y].range*Main.HEX_DISTANCE:
							char_data.attacks[y].in_range = true
					print(char_data.char_name+" CHOSE TARGET: "+collider.char_data.char_name)
					dmg_calc(collider.char_data)
					if collider.char_data.health <= 0:
						collider.die()
					break
				elif collider.char_data.allegiance == char_data.allegiance:
					print(char_data.char_name+" SPOTTED SAMEFOR!: "+char_data.char_name)
		else:
			print("no targets found for "+str(self))

func die():
	if char_data.death_sprite == null:
		rotation = 80
	else:
		self.texture = char_data.death_sprite
		
	if selected: selected = false

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
	
	if Main.turn == "player" and char_data.acted == false and char_data.health > 0:
		actionable_select.emit(self)
		print("ayo there's an actionable select done by "+str(self)+"!!")

func ordered_movement(target: Vector2i):
	self.position = target
	emit_signal("moved")

func find_targets(attack: Attack):
	var range = attack.range
	cast.shape.radius = (range+1)*Main.HEX_DISTANCE*1.25
	print(char_data.char_name+" is looking for targets...")
	for n in 2: await get_tree().process_frame
	if cast.is_colliding():
		for x in cast.collision_result.size():
			var collider = cast.collision_result[x]["collider"].get_parent()
			if collider is Character:
				print("available target for "+char_data.char_name+": "+collider.char_data.char_name)
				if collider.char_data.allegiance != self.char_data.allegiance and collider.char_data.health > 0:
					target_found.emit(collider, attack, char_data)
				elif collider.char_data.allegiance == char_data.allegiance:
					print(str(self)+" SPOTTED FRIENDLY: "+str(collider))

func enemy_find_targets(attack: Attack):
	var range = attack.range
	cast.shape.radius = (range+1)*Main.HEX_DISTANCE*3
	print(char_data.char_name+" is looking for targets...")
	for n in 2: await get_tree().process_frame
	if cast.is_colliding():
		for x in cast.collision_result.size():
			var collider = cast.collision_result[x]["collider"].get_parent()
			if collider is Character and collider.char_data.allegiance != self.char_data.allegiance and collider.char_data.health > 0:
				return collider
