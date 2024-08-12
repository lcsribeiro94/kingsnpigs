extends Area2D

@export var link : Area2D
var body

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	body = get_overlapping_bodies()
	if body != [] and body[0].name == "King":
		#print("King's here! Unlock the door")
		if Input.is_action_just_pressed("up"):
			body[0].current_state = "DOOR"
			$AnimatedSprite2D.play("open")
			
	if $AnimatedSprite2D.animation == "open" && $AnimatedSprite2D.get_playing_speed() == 0:
		if body[0]._get_animation() != "enter_door":
			body[0]._change_animation("enter_door")
		if body[0]._get_playing_speed() == 0:
			body[0].visible = false
			$AnimatedSprite2D.play("close")
		
	if $AnimatedSprite2D.animation == "close" && $AnimatedSprite2D.get_playing_speed() == 0:
			_teleport_player(body)
			body[0].visible = true
			$AnimatedSprite2D.play("idle")
			body[0].current_state = "FREE"

func _teleport_player(fbody : Array):
	fbody[0].position.x = link.position.x
	fbody[0].position.y = link.position.y
