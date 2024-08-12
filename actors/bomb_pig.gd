extends StaticBody2D

@onready var anim_sprite = $AnimatedSprite2D
@onready var bomb = $Bomb
@onready var launch_timer = $LaunchTimer
@onready var bomb_pig = $"."

var player_inrange: bool = false
var player_pos: Vector2

func _ready():
	anim_sprite.play("idle")

func _process(_delta):
	if player_inrange && launch_timer.is_stopped():
		launch_timer.start()

func _on_range_body_entered(body):
	if body.is_in_group("jogador"):
		if body.position.x < bomb_pig.position.x:
			scale.x = scale.x * -1
		player_inrange = true

func _on_launch_timer_timeout():
	launch_bomb()

func launch_bomb():
	bomb.visible = true
	anim_sprite.play("throw")
	bomb.anim_sprite.play("ticking")
	bomb.velocity = Vector2((10*bomb_pig.scale.x),-10)

func _on_animated_sprite_2d_animation_finished():
	match anim_sprite.animation:
		"throw":
			anim_sprite.play("pick_bomb")
		"pick_bomb":
			anim_sprite.play("idle")

func _on_range_body_exited(body):
	if body.is_in_group("jogador"):
		player_inrange = false
