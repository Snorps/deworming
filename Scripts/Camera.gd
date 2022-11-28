extends Camera2D

export(PackedScene) var gameOverScene

func gameOver():
	var gameover = gameOverScene.instance()
	add_child(gameover)


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.camera = self
	$DarknessLayer.targetPath = "../../Candle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset = GlobalVars.player.getClampedPosition()
