extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()
	new_game()

func _on_ScoreTimer_timeout():
	score += 1

func new_game():
	score = 0
	# $Player.start($StartPosition.position)
	$StartTimer.start()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
	
func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var ls = GameVars.levelSize
	#var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	#mob_spawn_location.offset = randi()
	
	var mobPos = Vector2(randf()*ls.x, randf()*ls.y)
	mobPos = mobPos - (ls/2)

	if randf() > 0.75:
		mobPos.x = -ls.x/2
	elif randf() > 0.5:
		mobPos.y = -ls.y/2
	elif randf() > 0.25:
		mobPos.x = ls.x/2
	else:
		mobPos.y = ls.y/2

	mob.position = mobPos
	add_child(mob)
