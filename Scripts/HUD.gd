extends Node

#export(PackedScene) var heartScene
#
#var hearts = []
#
#func clearHearts():
#	print(hearts.size())
#	var i = hearts.size() - 1
#	while i > 0:
#		hearts[i].queue_free()
#		i = i - 1
#
#func updateHearts():
#	clearHearts()
#	for i in GameVars.player.health:
#		var heart = heartScene.instance()
#		var x = hearts.size() * heart.frames.get_frame("default",0).get_width() * heart.scale.x
#		hearts.append(heart)
#		heart.position.x = x
#		$HeartContainer.add_child(heart)

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
