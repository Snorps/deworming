extends Area2D

signal hit

export var velocityStep = 160 # How fast the player will move (pixels/sec).
export var velocityMultiplier = 0.75
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

var walking
func _process(delta):
	ticksSinceHurt = ticksSinceHurt - 1
	if ticksSinceHurt <= 0:
		# $CollisionShape2D.set_deferred("enabled", true)
		var delet = 1
	
	walking = false
	if Input.is_action_pressed("move_right"):
		walking = true
		velocity.x += velocityStep
	if Input.is_action_pressed("move_left"):
		walking = true
		velocity.x -= velocityStep
	if Input.is_action_pressed("move_down"):
		walking = true
		velocity.y += velocityStep
	if Input.is_action_pressed("move_up"):
		walking = true
		velocity.y -= velocityStep

	velocity = velocity * velocityMultiplier
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# ANIMATION STUFFs
	if walking:
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
	
