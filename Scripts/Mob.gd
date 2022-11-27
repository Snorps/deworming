extends Area2D

signal hit

enum State {DEAD, DEFAULT, STUNNED}
var rand = RandomNumberGenerator.new()

export var velocityStep = 20
export var velocityMultiplier = 0.9
export var visionDistance = 400
export var stunTime = 3

var state
var velocity = Vector2.ZERO


func _on_Mob_area_entered(area):
	if area.name == "Melee" and state != State.DEAD:
		$AnimatedSprite.play("dead")
		state = State.DEAD
		emit_signal("hit")
		
		set_collision_layer_bit(0, 1)
		set_linear_damp(2)
		z_index = -2
		
		$AnimatedSprite.material.set_shader_param("active", true)
		get_tree().paused = true
		var time_in_seconds = 0.06
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		get_tree().paused = false
		$AnimatedSprite.material.set_shader_param("active", false)
	

func _on_Mob_body_entered(body):
	if body.name == "Candle" and state != State.DEAD:
		if GlobalVars.player.heldItem != body: #messyyy
			if abs(body.linear_velocity.x) > 0.1 or abs(body.linear_velocity.y) > 0.1:
				state = State.STUNNED
				$StunSprite.visible = true
				yield(get_tree().create_timer(stunTime), "timeout")
				if state == State.STUNNED:
					state = State.DEFAULT
				$StunSprite.visible = false
		
	

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

		velocity = velocity * velocityMultiplier
		
		position += velocity * delta
		
		#position.x = clamp(position.x, -level_size.x/2, level_size.x/2)
		#position.y = clamp(position.y, -level_size.y/2, level_size.y/2)

