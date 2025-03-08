extends Control
@onready var anim_player: AnimationPlayer = $AnimPlayer
@onready var splash_timer: Timer = $SplashTimer
@onready var bgm: AudioStreamPlayer = $BGM
@onready var credits: PanelContainer = $Credits


func _ready() -> void:
	anim_player.play("splash")


func _on_splash_timer_timeout() -> void:
	bgm.play()


func _on_quit_button_up() -> void:
	get_tree().quit()

func _on_new_run_button_up() -> void:
	Main.player_data = Main.GROUP_FOXTROT.duplicate()
	var run = RunData.new()
	run.blufor = Main.player_data
	run.progress = 0
	Main.run_data = run
	get_tree().change_scene_to_file("res://scenes/run_screen.tscn")

func _on_test_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/combat_tiles.tscn")

func _on_credits_button_up() -> void:
	credits.visible = true

func _on_close_credits_button_up() -> void:
	credits.visible = false
