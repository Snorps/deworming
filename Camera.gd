extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVars.camera = self
	$DarknessLayer.targetPath = "../../Player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset = GlobalVars.player.getClampedPosition()
