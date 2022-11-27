extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Grabbable_input_event(viewport, event, shape_idx):
	print("clickd")


func _on_Grabbable_mouse_entered():
	print("weed eater")
