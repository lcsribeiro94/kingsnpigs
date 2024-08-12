extends Area2D
class_name SmallPig

const HP = 10
var currentHP = HP
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if currentHP <= 0:
		$AnimatedSprite2D.play("death")


func _take_dmg(dmg: int):
	$AnimatedSprite2D.play("hit")
	currentHP = currentHP - dmg
	if $AnimatedSprite2D.get_animation() == "hit" && $AnimatedSprite2D.get_playing_speed() == 0:
		$AnimatedSprite2D.play("idle")
