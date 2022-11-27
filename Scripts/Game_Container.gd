extends Node

export(PackedScene) var gameScene

var gameOverSound = preload("res://Assets/Sounds/GameOver.wav")

var game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$MusicPlayer.stream = music
	#$MusicPlayer.play()

func _input(event):
	if event is InputEventMouseButton:
		if GlobalVars.state == GlobalVars.State.MENU:
			GlobalVars.state = GlobalVars.State.PLAYING
			game = gameScene.instance()
			add_child(game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalVars.state == GlobalVars.State.GAME_OVER:
		GlobalVars.state = GlobalVars.State.MENU
		$SoundPlayer.stream = gameOverSound
		$SoundPlayer.play()
		yield(get_tree().create_timer(5), "timeout")
		if is_instance_valid(game):
			game.queue_free()
