extends PanelContainer
@onready var sprite: TextureRect = $MainHBox/Sprite
@onready var name_label: Label = $MainHBox/NameLabel
@onready var hp_bar: ProgressBar = $MainHBox/HPVBox/HPBar
@onready var hp_label: Label = $MainHBox/HPVBox/HPLabel

var char_data: CharacterData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hp_bar.value = char_data.health
	hp_bar.max_value = char_data.max_health
	hp_label.text = "Health: "+str(char_data.health)+" / "+str(char_data.max_health)

func load_data(data: CharacterData):
	char_data = data
	sprite.texture = data.sprite
	name_label.text = data.char_name
