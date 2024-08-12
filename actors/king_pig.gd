extends StaticBody2D

@onready var king_pig = $"."
@onready var state_indicator = $AnimatedSprite2D/StateIndicator
@onready var attack_timer = $AttackTimer
@onready var rest_timer = $RestTimer
@onready var wait_before_attack = $WaitBeforeAttack
@onready var attack_duration_timer = $AttackDurationTimer
@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D

signal king_attack
signal end_game

enum STATES {
		IDLE,
		ATTACK,
		DAMAGE
	}

var curr_state = STATES.IDLE
var health = 5
var random
var can_attack = false

func _ready():
	animated_sprite_2d.play("idle")
	state_indicator_animation(curr_state)
	wait_before_attack.start()

func _process(delta):
	if animated_sprite_2d.animation == "damage" && animated_sprite_2d.get_playing_speed() == 0:
		animated_sprite_2d.play("idle")
	if health <= 0 && animated_sprite_2d.animation != "death":
		Engine.time_scale = 0.2
		animated_sprite_2d.play("death")
	if animated_sprite_2d.animation == "death" && animated_sprite_2d.get_playing_speed() == 0:
		visible = false
		queue_free()
		emit_signal("end_game")
	if curr_state == STATES.DAMAGE:
		state_indicator_animation(curr_state)
	if can_attack:
		curr_state = STATES.ATTACK
		state_indicator_animation(curr_state)

func state_indicator_animation(state):
	match state:
		0:
			state_indicator.visible = false
			if animated_sprite_2d.animation != "idle" && animated_sprite_2d.get_playing_speed() == 0:
				animated_sprite_2d.play("idle")
		1:
			attack_timer.start()
			if state_indicator.animation != "attack_state":
				state_indicator.visible = true
				state_indicator.play("attack_state")
				can_attack = false
		2:
			king_pig.collision_shape_2d.disabled = false
			if state_indicator.animation != "damage_state":
				state_indicator.visible = true
				state_indicator.play("damage_state")
				rest_timer.start()

func attack():
	emit_signal("king_attack")
	attack_duration_timer.start()

func _take_dmg(dmg: int):
	print(str("aqui"))
	king_pig.collision_shape_2d.disabled = true
	animated_sprite_2d.play("damage")
	king_pig.health -= dmg
	curr_state = STATES.IDLE

func _on_attack_timer_timeout():
	attack()


func _on_rest_timer_timeout():
	state_indicator.visible = false
	king_pig.collision_shape_2d.disabled = true
	king_pig.curr_state = STATES.IDLE
	wait_before_attack.start()


func _on_attack_duration_timer_timeout():
	king_pig.curr_state = STATES.DAMAGE


func _on_wait_before_attack_timeout():
	can_attack = true
