extends Control
@onready var unit_hbox: HBoxContainer = $UnitVBox/TeamStatus/StatusVBox/UnitHBox
@onready var status_vbox: VBoxContainer = $UnitVBox/TeamStatus/StatusVBox

@onready var venusian_text: Label = $UnitVBox/VenusianStatus/VenusianVBox/VenusianHBox/VenusianText
@onready var research_text: Label = $UnitVBox/ResearchTeam/ResearchVBox/ResearchHBox/ResearchText

@onready var breakout_susume: Button = $TrackLine/TrackVBox/BreakOut/Susume
@onready var enemyahead_susume: Button = $TrackLine/TrackVBox/EnemyAhead/Susume
@onready var finalstretch_susume: Button = $TrackLine/TrackVBox/FinalStretch/Susume


@onready var enemy_ahead: HBoxContainer = $TrackLine/TrackVBox/EnemyAhead
@onready var final_stretch: HBoxContainer = $TrackLine/TrackVBox/FinalStretch
@onready var you_gain_two: HBoxContainer = $TrackLine/TrackVBox/YouGainTwo

func _ready() -> void:
	show_progress(Main.run_data)

func load_team_data(team: TeamData, run: RunData):
	for n in team.lineup.size():
		var unit = team.lineup[n]
		var unit_box = unit_hbox.instantiate()
		var unit_icon = unit_hbox.get_node("UnitIcon")
		var unit_name = unit_hbox.get_node("UnitName")
		var hp = unit_hbox.get_node("UnitHealthPanel/UnitHealth")
		status_vbox.add_child(unit_box)
		if unit.health == 0: ###### if dead, pretty much
			unit_icon.texture = unit.death_sprite
		else:
			unit_icon.texture = unit.sprite
		unit_name.text = unit.char_name
		hp.text = unit.health+" / "+unit.max_health
	unit_hbox.visible = false
	
	match run.progress:
		0:
			venusian_text.text = "\"We've got to get out of here. Match my pace. We'll make it, trust me.\""
			research_text.text = "\"Heard loud and clear. Get a move on, boys!\""

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
			
