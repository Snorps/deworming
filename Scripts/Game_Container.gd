extends Node

export(PackedScene) var gameScene

var game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	game = gameScene.instance()
	add_child(game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass