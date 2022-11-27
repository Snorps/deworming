extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var targetPath

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var node = get_node(targetPath)
	print(node)
	$ScreenShaderFilter.material.set_shader_param("screenSize", get_viewport().size);
	$ScreenShaderFilter.material.set_shader_param("pos", node.position)
