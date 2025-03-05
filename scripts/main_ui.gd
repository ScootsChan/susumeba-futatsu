extends Control
@onready var team_name_label: Label = $PlayerBox/PlayerVBox/TeamNameLabel
@onready var player_vbox: VBoxContainer = $PlayerBox/PlayerVBox
@onready var enemy_name_label: Label = $EnemyBox/EnemyVBox/TeamNameLabel
@onready var enemy_vbox: VBoxContainer = $EnemyBox/EnemyVBox
@onready var action_menu: PanelContainer = $action_menu

const ATTACK_MENU = preload("res://scenes/attack_menu.tscn")
const CHAR_TICKER = preload("res://scenes/char_ticker.tscn")
const TEST_BLUFOR = preload("res://data/teams/test_BLUFOR.tres")
const TEST_OPFOR = preload("res://data/teams/test_OPFOR.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_player_data(TEST_BLUFOR)
	load_enemy_data(TEST_OPFOR)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_player_data(player_data: TeamData):
	team_name_label.text = player_data.team_name
	for n in player_data.lineup.size():
		var player_ticker = CHAR_TICKER.instantiate()
		player_vbox.add_child(player_ticker)
		player_ticker.load_data(player_data.lineup[n])
	action_menu.attacks_button.button_up.connect(attack_load)

func load_enemy_data(enemy_data: TeamData):
	enemy_name_label.text = enemy_data.team_name
	for n in enemy_data.lineup.size():
		var enemy_ticker = CHAR_TICKER.instantiate()
		enemy_vbox.add_child(enemy_ticker)
		enemy_ticker.theme_type_variation = "EnemyPanel"
		enemy_ticker.load_data(enemy_data.lineup[n])

func attack_load():
	var attack_menu = ATTACK_MENU.instantiate()
	add_child(attack_menu)
	attack_menu.load_data(action_menu.char_data)
	attack_menu.attack_requested.connect(action_menu.pass_attack_info)
