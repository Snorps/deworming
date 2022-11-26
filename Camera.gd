extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameVars.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset = GameVars.player.getClampedPosition()
