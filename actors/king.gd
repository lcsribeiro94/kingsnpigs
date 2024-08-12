extends CharacterBody2D

signal health_changed
signal player_died

const STATES = ['FREE', 'DOOR', 'ATTACK']
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_JUMPS = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_jumps = 0
var current_state = 'FREE'
var damage_dealt: int = 2
var current_health: int = 3
var max_health: int = 3
var hitstun: bool = false

func _ready():
	_change_animation("idle")

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if current_state == STATES[0]:
		if current_health > 0:
			PlayerStateFree(delta)

	if current_health <= 0 && _get_animation() != "death":
		Engine.time_scale = 0.2
		_change_animation("death")

	if _get_animation() == "death" && _get_playing_speed() == 0:
		visible = false
		queue_free()
		emit_signal("player_died")

	if _get_animation() == "hit" && _get_playing_speed() == 0:
		$CollisionShape2D.disabled = false
		_change_animation("idle")
		hitstun = false

func _change_animation(anim: String):
	$AnimatedSprite2D.play(anim)
	
func _animation_playing():
	return $AnimatedSprite2D.get_playing_speed()
	
func _get_playing_speed():
	return $AnimatedSprite2D.get_playing_speed()
	
func _get_animation():
	return $AnimatedSprite2D.get_animation()
	
func PlayerStateFree(_delta : float):
	if is_on_floor():
		current_jumps = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or current_jumps < MAX_JUMPS):
		velocity.y = JUMP_VELOCITY
		current_jumps += 1

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if hitstun == false && _get_animation() != "attack":
		if direction:
			_change_animation("walk")
			$AnimatedSprite2D.scale.x = direction
			velocity.x = direction * SPEED
			if direction < 0:
				$AnimatedSprite2D.scale.x = direction
		else:
			_change_animation("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide() 
	
	#Attack
	if Input.is_action_just_pressed("attack") && hitstun == false:
		if $AnimatedSprite2D.scale.x == 1:
			$AttackHurtBox/CollisionShapeRight.disabled = false
		if $AnimatedSprite2D.scale.x == -1:
			$AttackHurtBox/CollisionShapeLeft.disabled = false
		if _get_animation() != "attack":
			_change_animation("attack")
	if _get_animation() == "attack" && _get_playing_speed() == 0:
		_change_animation("idle")
		$AttackHurtBox/CollisionShapeLeft.disabled = true
		$AttackHurtBox/CollisionShapeRight.disabled = true

func _on_attack_hurt_box_body_entered(body):
	if body.is_in_group("inimigos"):
		body._take_dmg(damage_dealt)
		
func _take_dmg(dmg: int):
	if $AnimatedSprite2D.get_animation() != "hit":
		position -= Vector2((20 * $AnimatedSprite2D.scale.x),10)
		$CollisionShape2D.disabled = true
		hitstun = true
		$AnimatedSprite2D.play("hit")
		current_health = current_health - dmg
		emit_signal("health_changed")
		print(str(current_health))
