extends Node

var w

func updateHearts():
	var health = GlobalVars.player.health
	$TextureRect.rect_size.x = w * health
	$TextureRect.show()
	if health < 1:
		$TextureRect.hide()

var prevHealth
func _ready():
	w = $TextureRect.rect_size.x
#	prevHealth = GlobalVars.player.health
	#updateHearts()


func _process(delta):
	if prevHealth != GlobalVars.player.health:
		updateHearts()
	prevHealth = GlobalVars.player.health
	$FloorDisplay.text = "Floor " + str(GlobalVars.game.floors)
