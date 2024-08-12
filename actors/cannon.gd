extends AnimatedSprite2D

@onready var bullet = $Bullet
@onready var cannon = $"."

var bullet_speed = 200
var original_bullet_position

func _ready():
	original_bullet_position = bullet.position

func _process(delta):
	if bullet.visible:
		bullet.position.x -= bullet_speed * delta

func shoot():
	cannon.play("shoot")
	bullet.visible = true
	if cannon.animation == "shoot" && cannon.get_playing_speed() == 0:
		cannon.play("default")
	
func reposition_bullets():
	bullet.visible = false
	bullet.position = original_bullet_position

func _on_bullet_body_entered(body):
	if body.is_in_group("jogador"):
		body._take_dmg(1)
		reposition_bullets()
	if body.get_class() == "TileMap":
		if body.get_layer_name(1) == "Walls":
			reposition_bullets()
