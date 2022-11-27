extends Node

var w

func updateHearts():
	var health = GameVars.player.health
	$TextureRect.rect_size.x = w * health
	$TextureRect.show()
	if health < 1:
		$TextureRect.hide()

var prevHealth
func _ready():
	w = $TextureRect.rect_size.x
#	prevHealth = GameVars.player.health
	#updateHearts()


func _process(delta):
	if prevHealth != GameVars.player.health:
		updateHearts()
	prevHealth = GameVars.player.health
	$FloorDisplay.text = "Floor " + str(GameVars.floorCount)
