extends Resource
class_name CharacterData
##### Damage types: explosive, piercing, burn, emp

@export var char_name: String #name of character
@export var allegiance: String #side: BLUFOR, OPFOR, NEUFOR
@export var sprite: Texture2D
@export var death_sprite: Texture2D
@export var acted = false
@export var moved = false

@export var speed: int
@export var weakness: String
@export var enemy_type: String
@export var initiative: int

@export_subgroup("Health")
@export var health: int
@export var max_health: int

@export_category("Damage")
@export var attacks: Array[Attack]
