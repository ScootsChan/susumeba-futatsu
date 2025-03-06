extends Control
@onready var anim_player: AnimationPlayer = $AnimPlayer
@onready var splash_timer: Timer = $SplashTimer
@onready var bgm: AudioStreamPlayer = $BGM

func _ready() -> void:
	anim_player.play("splash")


func _on_splash_timer_timeout() -> void:
	bgm.play()


func _on_quit_button_up() -> void:
	get_tree().quit()

func _on_new_run_button_up() -> void:
	pass # Replace with function body.

func _on_test_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/combat_tiles.tscn")
