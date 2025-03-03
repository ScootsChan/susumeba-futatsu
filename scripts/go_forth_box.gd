extends HBoxContainer
@onready var anim_player: AnimationPlayer = $AnimPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("intro")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free()
