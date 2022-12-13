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
var calculatedThrowForce


var level_size = GlobalVars.levelSize

var velocity = Vector2.ZERO # The player's movement vector.

var viewportSize

func _ready():
	GlobalVars.player = self

var iframes = 15
func giveIframes():
	iframes = 65


func _on_Player_area_entered(area):
	if iframes <= 0 and area.name == "AttackHitbox" and state != PlayerState.DEAD:
		if area.get_owner().state == area.get_owner().State.AGGRO:
			giveIframes()
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
	viewportSize = get_viewport().size
	iframes = iframes - 1
	
	if health <= 0 and state != PlayerState.DEAD: #die if no health
		$WailPlayer.stream = hurtSoundLast
		$WailPlayer.play()
		
		$AnimatedSprite.play("dead")
		$AnimatedSprite.z_index = -1
		state = PlayerState.DEAD
		GlobalVars.state = GlobalVars.State.GAME_OVER
	
	if is_instance_valid(heldItem): #set held item position
		var displacement = get_global_position() - $HeldItemContainer/HeldItem.get_global_position()
		var direction = displacement.normalized()
		
		var distance = get_global_position().distance_to(get_global_mouse_position())
		distance = clamp(distance, 0, viewportSize.y/2.5)
		var distance_mapped = distance/(viewportSize.y/2.5)
		calculatedThrowForce = throwForce * distance_mapped
		var maximum = 80
		heldItem.position = get_global_position() + (direction * (-distance_mapped*maximum))
	
	if state != PlayerState.DEAD: #if alive, do player input logic
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
		elif velocity.y != 0:
			$AnimatedSprite.animation = "default"
	
	
var lastGrabTime = 0
var noThrowAfterGrabTime = 0.001
func grab(object):
	GlobalVars.speech_next()
	heldItem = object
	lastGrabTime = OS.get_ticks_msec()

	
func getClampedPosition():
	if level_size == null or viewportSize == null:
		return Vector2.ZERO
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
			heldItem.linear_velocity += $HeldItemContainer.get_global_transform().x.normalized() * calculatedThrowForce

			var path = NodePath(str(heldItem.get_path()) + "/GrabPoint")
			var grabPoint = get_node(path)
			var overlaps = grabPoint.get_overlapping_areas()
			for o in overlaps:
				if o.filename == "res://Scenes/Mob.tscn":
					o.projectileHit(heldItem)
			
			heldItem = null
		elif lastMeleeTime < OS.get_ticks_msec() - (meleeCooldown * 1000) and not state == PlayerState.DEAD:
			lastMeleeTime = OS.get_ticks_msec()
			$HeldItemContainer/HeldItem/Melee.set_collision_mask(1)
			if $HeldItemContainer/HeldItem/Melee/MeleeSprite.flip_v == false:
				$HeldItemContainer/HeldItem/Melee/MeleeSprite.flip_v = true;
			else:
				$HeldItemContainer/HeldItem/Melee/MeleeSprite.flip_v = false;
			$HeldItemContainer/HeldItem/Melee/MeleeSprite.play("swing")
			$SoundPlayer.stream = slashSound1
			$SoundPlayer.play()
			var time_in_seconds = 0.03
			yield(get_tree().create_timer(time_in_seconds), "timeout")
			velocity += $HeldItemContainer.get_global_transform().x.normalized() * meleeCarrythrough
			$HeldItemContainer/HeldItem/Melee.set_collision_mask(0)
	elif event is InputEventMouseMotion:
		var mousepos = GlobalVars.camera.get_global_mouse_position()
		$HeldItemContainer.look_at(mousepos)
		if mousepos.x > $AnimatedSprite.get_global_position().x:
			$AnimatedSprite.flip_h = false;
		else:
			$AnimatedSprite.flip_h = true;



func _on_Melee_animation_finished():
	$HeldItemContainer/HeldItem/Melee/MeleeSprite.play("default")
	var t = Timer.new()
	t.set_wait_time(1)
	$HeldItemContainer/HeldItem/Melee.set_collision_layer_bit(0, 0)
