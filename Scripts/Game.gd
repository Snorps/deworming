extends Node

#export(PackedScene) var mobScene
export(PackedScene) var levelScene
var score
var floors
var level

func nextLevel():
	if level != null:
		level.queue_free()
	level = levelScene.instance()
	add_child(level)
	GlobalVars.state = GlobalVars.State.PLAYING
	floors = floors + 1
	#$AudioStreamPlayer.stream = descendSound
	#$AudioStreamPlayer.play()

func _ready():
	floors = 0
	GlobalVars.game = self
	randomize()
	nextLevel()
	new_game()

func _process(_delta):
	if GlobalVars.state == GlobalVars.State.NEXT_LEVEL:
		nextLevel()

func _on_ScoreTimer_timeout():
	score += 1

func new_game():
	score = 0
	# $Player.start($StartPosition.position)
	$StartTimer.start()

func _on_StartTimer_timeout():
	$ScoreTimer.start()
	
func _input(event):
	if event is InputEventMouseButton and event.pressed == true:
		if is_instance_valid(GlobalVars.grabItem):
			GlobalVars.player.grab(GlobalVars.grabItem)
