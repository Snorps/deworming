extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _on_Grabbable_input_event(viewport, event, shape_idx):
#	if event is InputEventMouseButton and event.pressed == true:
#		GlobalVars.player.grab(self.owner)
	

func _on_Grabbable_mouse_entered():
	GlobalVars.grabItem = self.get_parent()


func _on_GrabPoint_mouse_exited():
	if GlobalVars.grabItem == self.get_parent():
		GlobalVars.grabItem = null
