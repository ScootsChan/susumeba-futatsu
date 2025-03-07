extends Control
@onready var unit_hbox: HBoxContainer = $UnitVBox/TeamStatus/StatusVBox/UnitHBox
@onready var status_vbox: VBoxContainer = $UnitVBox/TeamStatus/StatusVBox


func load_team_data(team: TeamData):
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
