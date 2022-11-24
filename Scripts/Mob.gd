extends RigidBody2D

signal hit


func _on_Area2D_area_entered(area):
	if area.name == "Melee":
		$AnimatedSprite.play("dead")
		emit_signal("hit")
		get_tree().paused = true
		var time_in_seconds = 0.1
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		get_tree().paused = false
		# Must be deferred as we can't change physics properties on a physics callback.
		# $CollisionShape2D.set_deferred("disabled", true)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

