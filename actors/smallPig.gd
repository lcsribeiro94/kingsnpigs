extends StaticBody2D

const HP = 10
var currentHP = HP
var direction : int = -1
var hitstun: bool = false
var is_attacking: bool = false
@export var SPEED : int = 30
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_player_left = $RayCastPlayerLeft
@onready var ray_cast_player_right = $RayCastPlayerRight

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.scale.x = -direction
	if $AnimatedSprite2D.scale.x == -1:
		ray_cast_player_right.enabled = true
		ray_cast_player_left.enabled = false
	if $AnimatedSprite2D.scale.x == 1:
		ray_cast_player_left.enabled = true
		ray_cast_player_right.enabled = false
	
	if currentHP <= 0 && $AnimatedSprite2D.get_animation() != "death":
		$CollisionShape2D.disabled = true
		$AnimatedSprite2D.play("death")
		
	if $AnimatedSprite2D.get_animation() == "death" && $AnimatedSprite2D.get_playing_speed() == 0:
		visible = false
		queue_free()
		
	if $AnimatedSprite2D.get_animation() == "hit" && $AnimatedSprite2D.get_playing_speed() == 0:
		$AnimatedSprite2D.play("idle")
		hitstun = false
		
	if $AnimatedSprite2D.get_animation() == "attack" && $AnimatedSprite2D.get_playing_speed() == 0:
		$AttackHurtBox/CollisionShapeLeft.disabled = true
		$AttackHurtBox/CollisionShapeLeft.disabled = true
		ray_cast_player_right.enabled = false
		ray_cast_player_right.enabled = false
		is_attacking = false
		$AnimatedSprite2D.play("idle")
		
	if hitstun == false:
		if ray_cast_player_left.is_colliding() || ray_cast_player_right.is_colliding():
			_attack_player()
		if !is_attacking:
			if $AnimatedSprite2D.get_animation() != "walk":
				$AnimatedSprite2D.play("walk")
			if ray_cast_left.is_colliding():
				direction = 1
			if ray_cast_right.is_colliding():
				direction = -1
			position.x += SPEED * delta * direction

func _take_dmg(dmg: int):
	hitstun = true
	$AnimatedSprite2D.play("hit")
	currentHP = currentHP - dmg

func _attack_player():
	is_attacking = true
	if $AnimatedSprite2D.get_animation() != "attack":
		$AnimatedSprite2D.play("attack")
	if $AnimatedSprite2D.get_animation() == "attack" && ($AnimatedSprite2D.frame >= 3 || $AnimatedSprite2D.frame <= 4):
		if $AnimatedSprite2D.scale.x == 1:
			$AttackHurtBox/CollisionShapeLeft.disabled = false
		if $AnimatedSprite2D.scale.x == -1:
			$AttackHurtBox/CollisionShapeRight.disabled = false

func _on_attack_hurt_box_body_entered(body):
	if body.is_in_group("jogador"):
		body._take_dmg(1)
