extends Area2D

signal hit
signal swing

export var velocityStep = 160 # How fast the player will move (pixels/sec).
export var velocityMultiplier = 0.75
export var meleeCooldown = 0.7

var screen_size # Size of the game window

var velocity = Vector2.ZERO # The player's movement vector.


func _ready():
	screen_size = get_viewport_rect().size
	velocity = Vector2.ZERO # The player's movement vector. when you WHEN YOU WHEN YOU
	


var ticksSinceHurt = 15
func _on_Player_body_entered(body):
	ticksSinceHurt = 65
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	ticksSinceHurt = ticksSinceHurt - 1
	if ticksSinceHurt <= 0:
		# $CollisionShape2D.set_deferred("enabled", true)
		var delet = 1
	
	var walkingdir = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		walkingdir.x += 1
	if Input.is_action_pressed("move_left"):
		walkingdir.x -= 1
	if Input.is_action_pressed("move_down"):
		walkingdir.y += 1
	if Input.is_action_pressed("move_up"):
		walkingdir.y -= 1
	velocity += walkingdir.normalized() * velocityStep

	velocity = velocity * velocityMultiplier
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# ANIMATION STUFFs
	if walkingdir != Vector2.ZERO:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.flip_v = velocity.y > 0
	
	
	
var lastMeleeTime = 0
func _input(event):
	if event is InputEventMouseButton:
		if lastMeleeTime < OS.get_ticks_msec() - (meleeCooldown * 1000):
			lastMeleeTime = OS.get_ticks_msec()
			$HeldItemContainer/HeldItem/Melee.set_collision_layer_bit(0, 1)
			$HeldItemContainer/HeldItem/Melee/MeleeSprite.play("swing")
			var time_in_seconds = 0.03
			yield(get_tree().create_timer(time_in_seconds), "timeout")
			velocity += $HeldItemContainer.get_global_transform().x.normalized() * 600
	elif event is InputEventMouseMotion:
		$HeldItemContainer.look_at(event.position)
		
	# print("Viewport Resolution is: ", get_viewport_rect().size)
	



func _on_Melee_animation_finished():
	$HeldItemContainer/HeldItem/Melee/MeleeSprite.play("default")
	var t = Timer.new()
	t.set_wait_time(1)
	$HeldItemContainer/HeldItem/Melee.set_collision_layer_bit(0, 0)
