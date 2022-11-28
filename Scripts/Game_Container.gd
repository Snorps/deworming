extends Node

export(PackedScene) var gameScene

var playSound = preload("res://Assets/Sounds/Slash.wav")

var gameOverSound = preload("res://Assets/Sounds/GameOver.wav")

var game


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true #audio wont play unless we do this for some reason
	get_tree().paused = false


var processedGameOver = false
func _input(event):
	if event is InputEventMouseButton and event.pressed == true:
		if GlobalVars.state == GlobalVars.State.MENU:
			processedGameOver = false
			GlobalVars.state = GlobalVars.State.PLAYING
			game = gameScene.instance()
			add_child(game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalVars.state == GlobalVars.State.GAME_OVER and processedGameOver == false:
		processedGameOver = true
		$SoundPlayer.stream = gameOverSound
		$SoundPlayer.play()
		yield(get_tree().create_timer(5), "timeout")
		if is_instance_valid(game):
			game.queue_free()
			GlobalVars.state = GlobalVars.State.MENU
