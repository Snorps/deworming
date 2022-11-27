extends Node

const holeScene = preload("res://Hole.tscn")

func randomSign():
	return (round(randf())*2)-1

# Called when the node enters the scene tree for the first time.
func _ready():
	var ls = GameVars.levelSize
	var pos = Vector2(randomSign()*(randf()*(ls.x/2))*0.9, randomSign()*(randf()*(ls.y/2))*0.9)
	
	
	var nodule = holeScene.instance()
	nodule.position = pos
	add_child(nodule)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
