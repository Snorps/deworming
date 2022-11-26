extends RigidBody2D

signal hit

enum State {dead, default}
var state

func _on_Area2D_area_entered(area):
	if area.name == "Melee" and not state == State.dead:
		$AnimatedSprite.play("dead")
		state = State.dead
		emit_signal("hit")
		
		set_collision_layer_bit(0, 1)
		set_linear_damp(2)
		z_index = -2
		
		$AnimatedSprite.material.set_shader_param("active", true)
		get_tree().paused = true
		var time_in_seconds = 0.1
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		get_tree().paused = false
		$AnimatedSprite.material.set_shader_param("active", false)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = rand_range(300.0, 450.0)
	look_at(Vector2(300,300))
	set_linear_velocity(get_global_transform().x.normalized() * velocity)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	var viewport = get_viewport().size
	# var pos = $ScreenBumpNotifier.position
	rotation_degrees = 180 - abs(rotation_degrees)
	set_linear_velocity(get_global_transform().x.normalized() * velocity)
	

