extends StaticBody2D

@onready var fuse_timer = $FuseTimer
@onready var anim_sprite = $AnimatedSprite2D
@onready var bomb = $"."

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dmg: int = 1
var og_position: Vector2
var velocity: Vector2

func _ready():
	og_position = bomb.position
	anim_sprite.play("idle")

func _physics_process(delta):
	velocity.y += gravity * delta
	position.y += velocity.y
	position.x += velocity.x
	if abs(velocity.x) != 0:
		velocity.x = floor((abs(velocity.x) - 2)) * scale.x * delta
	pass

func _on_explosion_area_body_entered(body):
	if body.is_in_group("jogador"):
		body._take_dmg(dmg)

func _on_fuse_timer_timeout():
	anim_sprite.play("boom")

func _on_animated_sprite_2d_animation_finished():
	match anim_sprite.animation:
		"boom":
			bomb.visible = false
			bomb.position = og_position

func _on_animated_sprite_2d_animation_changed():
	match anim_sprite.animation:
		"ticking":
			bomb.visible = true
			fuse_timer.start()
