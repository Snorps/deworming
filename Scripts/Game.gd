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
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()


	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position



	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
