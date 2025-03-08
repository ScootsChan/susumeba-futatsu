extends AudioStreamPlayer
const COGNITIVEDISSONANCE = preload("res://audio/music/cognitivedissonance.mp3")
const INAHEARTBEAT = preload("res://audio/music/inaheartbeat.mp3")

func play_bgm(level: int):
	match level:
		0, 1, 2:
			stream = COGNITIVEDISSONANCE
		3:
			stream = INAHEARTBEAT
	play()
