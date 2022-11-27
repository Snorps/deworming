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
	
	
#func _on_MobTimer_timeout():
#	var mob = mobScene.instance()
#	var ls = GlobalVars.levelSize
#	#var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
#	#mob_spawn_location.offset = randi()
#
#	var mobPos = Vector2(randf()*ls.x, randf()*ls.y)
#	mobPos = mobPos - (ls/2)
#
#	if randf() > 0.75:
#		mobPos.x = -ls.x/2
#	elif randf() > 0.5:
#		mobPos.y = -ls.y/2
#	elif randf() > 0.25:
#		mobPos.x = ls.x/2
#	else:
#		mobPos.y = ls.y/2
#
#	mob.position = mobPos
#	level.add_child(mob)
