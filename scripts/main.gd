#### global main singleton
extends Node
const TEST_CHAR = preload("res://data/characters/test_char.tres")
const HEX_DISTANCE = 100

var characters = {
	"test" = TEST_CHAR,
	"test enemy" = preload("res://data/characters/test_enemy.tres")
}
var terrains = {
	"plains": Vector2i(2,1),
	"forest": Vector2i(3,1)
}

var damage_conversion = {
	"explosive": "explosive"
}

var damage_icons = {
	"explosive": Rect2(0,0,128,128),
	"piercing": Rect2(128,0,128,128),
	"burn": Rect2(256,0,128,128),
	"corrosive": Rect2(384,0,128,128),
	"electrical": Rect2(512,0,128,128)
}

func turn_end(team: TeamData):
	for n in team.lineup.size():
		team.lineup[n].acted = false
