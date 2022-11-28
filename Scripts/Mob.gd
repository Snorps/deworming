extends Area2D

signal hit

enum State {DEAD, DEFAULT, STUNNED}
var rand = RandomNumberGenerator.new()

export var velocityStep = 20
export var velocityMultiplier = 0.9
export var visionDistance = 400
export var stunTime = 3
export var health = 2

var state
var velocity = Vector2.ZERO

func showDamage(pos):
	var knockback = 150
	
	$AnimatedSprite.material.set_shader_param("active", true)
	get_tree().paused = true
	var vectorTo = (get_global_position() - pos).normalized()
	velocity += vectorTo * knockback
	yield(get_tree().create_timer(0.06), "timeout")
	
	$AnimatedSprite.material.set_shader_param("active", false)
	get_tree().paused = false

func _on_Mob_area_entered(area):
	if area.name == "Melee" and state != State.DEAD:
		if health <= 1 or state == State.STUNNED:
			$AnimatedSprite.play("dead")
			
			state = State.DEAD
			emit_signal("hit")
			
			set_collision_layer_bit(0, 1)
			set_linear_damp(2)
			z_index = -2
			$StunSprite.visible = false
		showDamage(area.get_global_position())
		health = health - 1

func projectileHit(body):
	if abs(body.linear_velocity.x) > 0.5 or abs(body.linear_velocity.y) > 0.5:
		body.linear_velocity = body.linear_velocity * 0.6 #reduce candle velocity
		state = State.STUNNED
		$StunSprite.visible = true
		showDamage(body.get_global_position())
		
		yield(get_tree().create_timer(stunTime), "timeout") # wait several seconds
		
		if state == State.STUNNED: #if still stunned, unstun
			$StunSprite.visible = false
			state = State.DEFAULT

func _on_Mob_body_entered(body):
	if body.name == "Candle" and state != State.DEAD:
		if GlobalVars.player.heldItem != body: #messyyy
			projectileHit(body)



func _ready():
	state = State.DEFAULT
	rand.randomize()
	
	
func _process(delta):
	if state == State.DEFAULT:
		var walkingdir = Vector2.ZERO
		var p = GlobalVars.player
		if p.position.x > position.x:
			walkingdir.x += 1
		if p.position.x < position.x:
			walkingdir.x -= 1
		if p.position.y > position.y:
			walkingdir.y += 1
		if p.position.y < position.y:
			walkingdir.y -= 1
			
		if position.distance_to(GlobalVars.player.position) > visionDistance:
			walkingdir = Vector2.ZERO
			
		velocity += walkingdir.normalized() * velocityStep

		if velocity.x != 0:
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.flip_v = false
			# See the note below about boolean assignment.
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite.animation = "default"
			$AnimatedSprite.flip_v = velocity.y > 0
			
	velocity = velocity * velocityMultiplier
	position += velocity * delta

