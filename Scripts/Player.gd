extends Area2D

signal hit
signal swing

var slashSound1 = preload("res://Assets/Sounds/Slash.wav")
var hurtSound = preload("res://Assets/Sounds/PlayerHurt.wav")

var health = 3

enum PlayerState {DEFAULT, DEAD}
var state = PlayerState.DEFAULT

export var velocityStep = 160 # How fast the player will move (pixels/sec).
export var velocityMultiplier = 0.75
export var meleeCooldown = 0.7

var screen_size # Size of the game window

var velocity = Vector2.ZERO # The player's movement vector.


func _ready():
	screen_size = get_viewport_rect().size
	


var ticksSinceHurt = 15
func _on_Player_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if ticksSinceHurt <= 0 and body.filename == "res://Mob.tscn" and state != PlayerState.DEAD:
		if body.state != body.State.dead:
			ticksSinceHurt = 65
			emit_signal("hit")
			health = health - 1
			
			$AudioStreamPlayer2D.stream = hurtSound
			$AudioStreamPlayer2D.play()
			
			$AnimatedSprite.material.set_shader_param("active", true)
			var time_in_seconds = 0.2
			yield(get_tree().create_timer(time_in_seconds), "timeout")
			$AnimatedSprite.material.set_shader_param("active", false)



func _process(delta):
	ticksSinceHurt = ticksSinceHurt - 1
	if health <= 0 and state != PlayerState.DEAD:
		$AnimatedSprite.play("dead")
		$AnimatedSprite.z_index = -1
		state = PlayerState.DEAD
		GameVars.state = GameVars.State.GAME_OVER
	
	if state != PlayerState.DEAD:
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
		yield(get_tree().create_timer(0.2), "timeout")
		if lastMeleeTime < OS.get_ticks_msec() - (meleeCooldown * 1000) and not state == PlayerState.DEAD:
			lastMeleeTime = OS.get_ticks_msec()
			$HeldItemContainer/HeldItem/Melee.set_collision_layer_bit(0, 1)
			$HeldItemContainer/HeldItem/Melee/MeleeSprite.play("swing")
			$AudioStreamPlayer2D.stream = slashSound1
			$AudioStreamPlayer2D.play()
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

