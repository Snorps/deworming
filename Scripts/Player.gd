extends Area2D

export(PackedScene) var levelScene

signal hit
signal swing

var slashSound1 = preload("res://Assets/Sounds/Slash.wav")
var hitSound = preload("res://Assets/Sounds/PlayerHit.wav")
var hurtSound = preload("res://Assets/Sounds/PlayerWail.wav")
var hurtSoundLast = preload("res://Assets/Sounds/PlayerWailLast.wav")


enum PlayerState {DEFAULT, DEAD}
var state = PlayerState.DEFAULT
var heldItem = null

export var health = 5
export var velocityStep = 80 
export var velocityMultiplier = 0.8
export var meleeCooldown = 0.2
export var meleeCarrythrough = 500

export var throwForce = 2000


var level_size = GlobalVars.levelSize

var velocity = Vector2.ZERO # The player's movement vector.

var viewportSize

func _ready():
	viewportSize = get_viewport().size
	GlobalVars.player = self


var ticksSinceHurt = 15
func _on_Player_area_entered(area):
	if ticksSinceHurt <= 0 and area.name == "AttackHitbox" and state != PlayerState.DEAD:
		if area.get_owner().state == area.get_owner().State.DEFAULT:
			ticksSinceHurt = 65
			emit_signal("hit")
			health = health - 1
			
			$SoundPlayer.stream = hitSound
			$SoundPlayer.play()
			
			if health > 0:
				$WailPlayer.stream = hurtSound
				$WailPlayer.play()
				
				$AnimatedSprite.material.set_shader_param("active", true)
				var time_in_seconds = 0.2
				yield(get_tree().create_timer(time_in_seconds), "timeout")
				$AnimatedSprite.material.set_shader_param("active", false)



func _process(delta):
	ticksSinceHurt = ticksSinceHurt - 1
	if health <= 0 and state != PlayerState.DEAD:
		$WailPlayer.stream = hurtSoundLast
		$WailPlayer.play()
		
		$AnimatedSprite.play("dead")
		$AnimatedSprite.z_index = -1
		state = PlayerState.DEAD
		GlobalVars.state = GlobalVars.State.GAME_OVER
	
	if is_instance_valid(heldItem):
		heldItem.position = $HeldItemContainer/HeldItem.get_global_position()
	
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
		position.x = clamp(position.x, -level_size.x/2, level_size.x/2)
		position.y = clamp(position.y, -level_size.y/2, level_size.y/2)

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
	
	
var lastGrabTime = 0
var noThrowAfterGrabTime = 0.001
func grab(object):
	heldItem = object
	lastGrabTime = OS.get_ticks_msec()

	
func getClampedPosition():
	var pos = Vector2(position.x, position.y)
	var upperbounds = level_size/2 - (viewportSize/2)
	var lowerbounds = -level_size/2 + (viewportSize/2)
	var s = pos.sign()
	
	#pos = Vector2(abs(pos.x),abs(pos.y)) - bounds
	#pos = s * pos
	
	pos.x = clamp(pos.x, lowerbounds.x, upperbounds.x)
	pos.y = clamp(pos.y, lowerbounds.y, upperbounds.y)
		
	return pos
	
var lastMeleeTime = 0
func _input(event):
	if event is InputEventMouseButton and event.pressed == true:
		if is_instance_valid(heldItem) and lastGrabTime + (noThrowAfterGrabTime*1000) < OS.get_ticks_msec():
			heldItem.linear_velocity += $HeldItemContainer.get_global_transform().x.normalized() * throwForce
			heldItem = null
		elif lastMeleeTime < OS.get_ticks_msec() - (meleeCooldown * 1000) and not state == PlayerState.DEAD:
			lastMeleeTime = OS.get_ticks_msec()
			$HeldItemContainer/HeldItem/Melee.set_collision_mask(1)
			$HeldItemContainer/HeldItem/Melee/MeleeSprite.play("swing")
			$SoundPlayer.stream = slashSound1
			$SoundPlayer.play()
			var time_in_seconds = 0.03
			yield(get_tree().create_timer(time_in_seconds), "timeout")
			velocity += $HeldItemContainer.get_global_transform().x.normalized() * meleeCarrythrough
			$HeldItemContainer/HeldItem/Melee.set_collision_mask(0)
	elif event is InputEventMouseMotion:
		$HeldItemContainer.look_at(GlobalVars.camera.get_global_mouse_position())



func _on_Melee_animation_finished():
	$HeldItemContainer/HeldItem/Melee/MeleeSprite.play("default")
	var t = Timer.new()
	t.set_wait_time(1)
	$HeldItemContainer/HeldItem/Melee.set_collision_layer_bit(0, 0)
