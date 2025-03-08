extends Control
const TEST_RUN = preload("res://data/test_run.tres")

const UNIT_HBOX = preload("res://scenes/unit_hbox.tscn")

const BREAKOUT = preload("res://data/maps/breakout.tres")
const BREAKOUT_OPFOR = preload("res://data/teams/opfor/breakout_opfor.tres")

@onready var status_vbox: VBoxContainer = $UnitVBox/TeamStatus/StatusVBox

@onready var venusian_text: Label = $UnitVBox/VenusianStatus/VenusianVBox/VenusianHBox/VenusianText
@onready var research_text: Label = $UnitVBox/ResearchTeam/ResearchVBox/ResearchHBox/ResearchText

@onready var breakout_susume: Button = $TrackLine/TrackVBox/BreakOut/Susume
@onready var enemyahead_susume: Button = $TrackLine/TrackVBox/EnemyAhead/Susume
@onready var finalstretch_susume: Button = $TrackLine/TrackVBox/FinalStretch/Susume


@onready var enemy_ahead: HBoxContainer = $TrackLine/TrackVBox/EnemyAhead
@onready var final_stretch: HBoxContainer = $TrackLine/TrackVBox/FinalStretch
@onready var you_gain_two: HBoxContainer = $TrackLine/TrackVBox/YouGainTwo

@onready var pause: PanelContainer = $Pause


func _ready() -> void:
	show_progress(Main.run_data)
	#show_progress(TEST_RUN)

func load_team_data(team: TeamData, run: RunData):
	match run.progress:
		0:
			venusian_text.text = "\"We've got to get out of here. Match my pace. We'll make it, trust me.\""
			research_text.text = "\"Heard loud and clear. Get a move on, boys!\""
		1:
			for n in team.lineup.size():
				var unit = team.lineup[n]
				if unit.health > 0 and unit.health != unit.max_health:
					unit.health += 1
			venusian_text.text = "\"Let's get rest and repair while we can. We're moving at dawn.\""
	
	for n in team.lineup.size():
		var unit_box = UNIT_HBOX.instantiate()
		status_vbox.add_child(unit_box)
		unit_box.load_data(team.lineup[n])
	
	

func show_progress(run: RunData):
	load_team_data(run.blufor, run)
	match run.progress:
		0:
			enemy_ahead.visible = false
			final_stretch.visible = false
			you_gain_two.visible = false
		1:
			breakout_susume.disabled = true
			enemy_ahead.visible = true
		2:
			breakout_susume.disabled = true
			enemyahead_susume.disabled = true
			enemy_ahead.visible = true
			final_stretch.visible = true
		3:
			breakout_susume.disabled = true
			enemyahead_susume.disabled = true
			finalstretch_susume.disabled = true
			enemy_ahead.visible = true
			final_stretch.visible = true
			you_gain_two.visible = true


func _on_breakout_susume_button_up() -> void:
	Main.map_data = BREAKOUT
	Main.enemy_data = BREAKOUT_OPFOR
	get_tree().change_scene_to_file("res://scenes/combat_tiles.tscn")

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
