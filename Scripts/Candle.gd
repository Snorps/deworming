extends "res://Scripts/Grabbable.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVars.grabItem == self:
		$Sprite.material.set_shader_param("active", true)
	else:
		$Sprite.material.set_shader_param("active", false)
	
	if position.x > (GlobalVars.levelSize.x/2):
		position.x = (GlobalVars.levelSize.x/2)
	elif position.x < (-GlobalVars.levelSize.x/2):
		position.x = -(GlobalVars.levelSize.x/2)
	
	if position.y > (GlobalVars.levelSize.y/2):
		position.y = (GlobalVars.levelSize.y/2)
	elif position.y < (-GlobalVars.levelSize.y/2):
		position.y = -(GlobalVars.levelSize.y/2)
