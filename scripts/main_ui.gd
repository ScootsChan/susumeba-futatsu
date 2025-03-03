extends Control
@onready var team_name_label: Label = $PlayerBox/PlayerVBox/TeamNameLabel
@onready var player_vbox: VBoxContainer = $PlayerBox/PlayerVBox

const CHAR_TICKER = preload("res://scenes/char_ticker.tscn")
const TEST_BLUFOR = preload("res://data/teams/test_BLUFOR.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_data(TEST_BLUFOR)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_data(player_data: TeamData):
	team_name_label.text = player_data.team_name
	for n in player_data.lineup.size():
		var player_ticker = CHAR_TICKER.instantiate()
		player_ticker.load_data(player_data.lineup[n])
		player_vbox.add_child(player_ticker)
