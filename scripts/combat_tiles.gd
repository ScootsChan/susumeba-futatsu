extends TileMapLayer

const TEST_MAP = preload("res://data/maps/test_map.tres")
const CHARACTER = preload("res://scenes/character.tscn")
const CHAR_TICKER = preload("res://scenes/char_ticker.tscn")
@onready var cam: Camera2D = $Camera2D
@onready var main_ui: Control = $Camera2D/CanvasLayer/main_ui

const GO_FORTH = preload("res://scenes/go_forth_box.tscn")
const PREPARE_THYSELF = preload("res://scenes/prepare_thyself.tscn")
const TEST_BLUFOR = preload("res://data/teams/test_BLUFOR.tres")
const TEST_OPFOR = preload("res://data/teams/test_OPFOR.tres")
const ACTION_MENU = preload("res://scenes/action_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_map_data(TEST_MAP, TEST_BLUFOR, TEST_OPFOR)
	player_turn(TEST_BLUFOR)
	#pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_turn(player_data: TeamData):
	Main.turn = "player"
	var dont_look_back = GO_FORTH.instantiate()
	main_ui.add_child(dont_look_back)
	
	for n in player_data.lineup.size():
		player_data.lineup[n].acted = false
		

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

func begin_action(char_data: CharacterData):
	main_ui.action_menu.visible = true
	main_ui.action_menu.load_char(char_data)
