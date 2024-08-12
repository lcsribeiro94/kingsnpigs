extends Node2D

@onready var player_cam = $Player/King/PlayerCam
@onready var boss_cam = $BossArea/BossCam
@onready var pause_menu = $PauseMenu
@onready var cannons = $Boss/Cannons
@onready var player_health = $GUI/HBoxContainer/ProgressBar
@onready var player = $Player/King


var paused = false

func _ready():
	player_health.max_value = player.max_health
	player_health.value = player.current_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_boss_area_body_entered(body):
	if body.is_in_group("jogador"):
		boss_cam.enabled = true
		player_cam.enabled = false

func _on_king_pig_king_attack():
	var chance
	var curr_cannons = cannons.get_children()
	for n in range(0, 30):
		chance = randi_range(0, 100)
		if chance < 70:
			curr_cannons[n].shoot()

func _on_king_pig_end_game():
	get_tree().change_scene_to_file("res://menu/main_menu.gd")


func _on_king_health_changed():
	player_health.value = player.current_health

func _on_king_player_died():
	get_tree().change_scene_to_file("res://menu/main_menu.gd")
