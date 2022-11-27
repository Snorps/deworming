extends Node

export(PackedScene) var mobScene
export var mobDensity = 0.4

const holeScene = preload("res://Hole.tscn")

func randomSign():
	return (round(randf())*2)-1

func randomPos():
	var ls = GlobalVars.levelSize
	var pos = Vector2(randomSign()*(randf()*(ls.x/2))*0.9, randomSign()*(randf()*(ls.y/2))*0.9)
	return pos

# Called when the node enters the scene tree for the first time.
func _ready():
	var mobCount = round(((GlobalVars.levelSize.x * GlobalVars.levelSize.y)/100000)*mobDensity)
	print(mobCount)
	for i in mobCount:
		var mob = mobScene.instance()
		mob.position = randomPos()
		add_child(mob)
	
	
	var nodule = holeScene.instance()
	nodule.position = randomPos()
	add_child(nodule)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
