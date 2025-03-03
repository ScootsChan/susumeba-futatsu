extends TileMapLayer

const TEST_MAP = preload("res://data/maps/test_map.tres")
const CHARACTER = preload("res://scenes/character.tscn")
const CHAR_TICKER = preload("res://scenes/char_ticker.tscn")
@onready var cam: Camera2D = $Camera2D
@onready var main_ui: Control = $Camera2D/CanvasLayer/main_ui

const GO_FORTH = preload("res://scenes/go_forth_box.tscn")
const PREPARE_THYSELF = preload("res://scenes/prepare_thyself.tscn")
const TEST_BLUFOR = preload("res://data/teams/test_BLUFOR.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_map_data(TEST_MAP)
	player_turn(TEST_BLUFOR)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_turn(player_data: TeamData):
	var dont_look_back = GO_FORTH.instantiate()
	main_ui.add_child(dont_look_back)

func load_map_data(data:MapData):
	for n in data.tile_data.size():
		set_cell(data.tile_data[n].location, 0, Main.terrains[data.tile_data[n].terrain_type])
		if data.tile_data[n].character_spawn != "":
			var new_char =  CHARACTER.instantiate()
			self.add_child(new_char)
			new_char.position = map_to_local(data.tile_data[n].location)
			new_char.load_data(Main.characters[data.tile_data[n].character_spawn])
			new_char.load_char()
			print("DEPLOYING NEW CHARACTER!: "+data.tile_data[n].character_spawn)
	for x in data.map_size:
		for y in data.map_size:
			if get_cell_tile_data(Vector2i(x,y)) == null:
				set_cell(Vector2i(x,y),0,Vector2i(2,0))
	cam.position = Vector2i(data.map_size*Main.HEX_DISTANCE*0.5,data.map_size*Main.HEX_DISTANCE*0.5)

func load_battle_data(player_data: TeamData, enemy_data: TeamData):
	for n in player_data.lineup.size():
		var char_ticker = CHAR_TICKER.instantiate()
		main_ui.add_child(char_ticker)
