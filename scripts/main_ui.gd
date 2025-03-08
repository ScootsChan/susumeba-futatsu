extends Control
@onready var team_name_label: Label = $PlayerBox/PlayerVBox/TeamNameLabel
@onready var player_vbox: VBoxContainer = $PlayerBox/PlayerVBox
@onready var enemy_name_label: Label = $EnemyBox/EnemyVBox/TeamNameLabel
@onready var enemy_vbox: VBoxContainer = $EnemyBox/EnemyVBox
@onready var action_menu: PanelContainer = $action_menu
@onready var pause: PanelContainer = $Pause
@onready var progress: Label = $GameOver/GameOverVBox/Progress
@onready var game_over: PanelContainer = $GameOver
@onready var victory: PanelContainer = $Victory
@onready var happy_ticker: Label = $Victory/VictoryVBox/HappyTicker
@onready var victory_continue: Button = $Victory/VictoryVBox/Continue



const ATTACK_MENU = preload("res://scenes/attack_menu.tscn")
const CHAR_TICKER = preload("res://scenes/char_ticker.tscn")
const TEST_BLUFOR = preload("res://data/teams/test_BLUFOR.tres")
const TEST_OPFOR = preload("res://data/teams/test_OPFOR.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_player_data(Main.player_data)
	load_enemy_data(Main.enemy_data)
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

func _input(event) -> void:
	if Input.is_action_pressed("escape"):
		if pause.visible == true:
			pause.visible = false
		else:
			pause.visible = true

func _on_main_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_button_up() -> void:
	get_tree().quit()


func _on_return_button_up() -> void:
	pause.visible = false

func show_game_over():
	progress.text = "You made it to: Stage "+str(Main.run_data.progress+1)
	game_over.visible = true

func show_victory():
	victory.visible = true
	match Main.run_data.progress:
		0:
			happy_ticker.text = "We've broken through! Let's keep moving forward!"
		1:
			happy_ticker.text = "They won't stand a chance against us. To the space elevator."
		2:
			happy_ticker.text = "We're almost home safe. Keep moving forward!"
		3:
			happy_ticker.text = "The color of the sky is beautiful up here..."
			victory_continue.text = "Celebrate victory."

func _on_continue_button_up() -> void:
	if Main.run_data.progress != 3:
		Main.run_data.progress += 1
		get_tree().change_scene_to_file("res://scenes/run_screen.tscn")
