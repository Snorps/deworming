extends Node

export(PackedScene) var gameScene

var music = preload("res://Assets/Sounds/musicb.mp3")
var gameOverSound = preload("res://Assets/Sounds/GameOver.wav")

var game


# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicPlayer.stream = music
	$MusicPlayer.play()

func _input(event):
	if event is InputEventMouseButton:
		if GameVars.state == GameVars.State.MENU:
			GameVars.state = GameVars.State.PLAYING
			game = gameScene.instance()
			add_child(game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameVars.state == GameVars.State.GAME_OVER:
		GameVars.state = GameVars.State.MENU
		print(GameVars.state)
		$SoundPlayer.stream = gameOverSound
		$SoundPlayer.play()
		yield(get_tree().create_timer(4), "timeout")
		if is_instance_valid(game):
			game.queue_free()
