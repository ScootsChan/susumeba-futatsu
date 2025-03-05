extends TileMapLayer

const TEST_MAP = preload("res://data/maps/test_map.tres")
const CHARACTER = preload("res://scenes/character.tscn")
const CHAR_TICKER = preload("res://scenes/char_ticker.tscn")
@onready var cam: Camera2D = $Camera2D
@onready var main_ui: Control = $Camera2D/MainCanvas/main_ui
@onready var move_buttons: Control = $CanvasLayer/MoveButtons
@onready var main_canvas: CanvasLayer = $Camera2D/MainCanvas

const GO_FORTH = preload("res://scenes/go_forth_box.tscn")
const PREPARE_THYSELF = preload("res://scenes/prepare_thyself.tscn")
const TEST_BLUFOR = preload("res://data/teams/test_BLUFOR.tres")
const TEST_OPFOR = preload("res://data/teams/test_OPFOR.tres")
const ACTION_MENU = preload("res://scenes/action_menu.tscn")
const MOVE_BUTTON = preload("res://scenes/move_button.tscn")
const TARGET_BUTTON = preload("res://scenes/target_button.tscn")

signal cleaned
var selected_char: Character
var player: TeamData
var enemy: TeamData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_map_data(TEST_MAP, TEST_BLUFOR, TEST_OPFOR)
	player = TEST_BLUFOR
	enemy = TEST_OPFOR
	player_turn(player)
	#pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Main.turn == "player":
		if check_acted(player) == true:
			enemy_turn(enemy)
	else:
		if check_acted(enemy) == true:
			player_turn(player)
			
func check_acted(checkee: TeamData) -> bool:
	for n in checkee.lineup.size():
		if checkee.lineup[n].acted == false:
			return false
	return true

func player_turn(player_data: TeamData):
	Main.turn = "player"
	var dont_look_back = GO_FORTH.instantiate()
	move_buttons.add_child(dont_look_back)
	
	for n in player_data.lineup.size():
		player_data.lineup[n].acted = false
		player_data.lineup[n].moved = false

func enemy_turn(enemy_data: TeamData):
	Main.turn = "enemy"
	var tatakae = PREPARE_THYSELF.instantiate()
	move_buttons.add_child(tatakae)

func load_map_data(data:MapData, player_data: TeamData, enemy_data: TeamData):
	var player_starting_cell: Vector2i
	var enemy_starting_cell: Vector2i
	
	for n in data.tile_data.size():
		set_cell(data.tile_data[n].location, 0, Main.terrains[data.tile_data[n].terrain_type])
		if data.tile_data[n].extra_data == "player start":
			for z in player_data.lineup.size():
				var new_char =  CHARACTER.instantiate()
				self.add_child(new_char)
				new_char.position = map_to_local(data.tile_data[n].location+(Main.postures[player_data.posture])[z])
				new_char.load_data(player_data.lineup[z])
				new_char.actionable_select.connect(self.begin_action)
				main_ui.action_menu.movement_requested.connect(character_movement)
				new_char.target_found.connect(self.place_target)
				new_char.load_char()
		if data.tile_data[n].extra_data == "enemy start":
			for z in enemy_data.lineup.size():
				var new_char =  CHARACTER.instantiate()
				self.add_child(new_char)
				new_char.position = map_to_local(data.tile_data[n].location+(Main.postures[enemy_data.posture])[z])
				new_char.load_data(enemy_data.lineup[z])
				new_char.load_char()
	for x in data.map_size:
		for y in data.map_size:
			if get_cell_tile_data(Vector2i(x,y)) == null:
				set_cell(Vector2i(x,y),0,Vector2i(2,0))
	cam.position = Vector2i(data.map_size*Main.HEX_DISTANCE*0.5,data.map_size*Main.HEX_DISTANCE*0.5)

func load_battle_data(player_data: TeamData, enemy_data: TeamData):
	for n in player_data.lineup.size():
		var char_ticker = CHAR_TICKER.instantiate()
		main_ui.add_child(char_ticker)

func begin_action(char: Character):
	main_ui.action_menu.visible = true
	main_ui.action_menu.load_char(char)
	if selected_char != null:
		main_ui.action_menu.attack_requested.disconnect(selected_char.find_targets)
	main_ui.action_menu.attack_requested.connect(char.find_targets)
	selected_char = char

func character_movement(char: Character): ################# This entire movement section is horrendous. I apologize if you need to clean up my mess. -Danny
	var char_data = main_ui.action_menu.char_data
	var char_speed = char_data.speed
	while char_speed > 0:
		var cells = get_surrounding_cells(local_to_map(char.position))
		print(char.position)
		char_data.moved = false
		char.moved.connect(skibidi_clean)
		for n in cells.size():
			var move_here = MOVE_BUTTON.instantiate()
			#print("shittin out my goddamn buttons at "+str(cells[n]))
			move_buttons.add_child(move_here)
			move_here.position = map_to_local(cells[n])-Vector2(0,20)
			move_here.move_here.connect(selected_char.ordered_movement.bind(map_to_local(cells[n])))
		await cleaned
		char_speed -= 1
		print("CHAR SPEED CURRENTLY: "+str(char_speed))
	char_data.moved = true
	main_ui.action_menu.movement_button.disabled = true

func place_target(target: Character, attack: Attack, attacker: CharacterData):
	var target_button = TARGET_BUTTON.instantiate()
	move_buttons.add_child(target_button)
	target_button.position = target.position-Vector2(50,50)
	target_button.assigned_target = target
	target_button.attack = attack
	target_button.attacker = attacker
	target_button.target_chosen.connect(bangbang)

func skibidi_clean():
	for n in move_buttons.get_children().size():
		move_buttons.get_children()[n].queue_free()
	cleaned.emit()

func bangbang(target: Character, attack: Attack, attacker: CharacterData):
	target.take_damage(attack)
	main_ui.action_menu.visible = false
	attacker.acted = true
	skibidi_clean()
