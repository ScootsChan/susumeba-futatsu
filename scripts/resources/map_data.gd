extends Resource
class_name MapData

@export var map_name: String
@export var map_size: int #All maps are square by design.
@export var tile_data: Array[Hex]
