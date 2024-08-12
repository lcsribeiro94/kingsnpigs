extends Control

@onready var pause_menu = $"."
@onready var game = $".."

func _on_btn_resume_pressed():
	game.paused_menu()
	pass # Replace with function body.


func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
	pass # Replace with function body.


func _on_btn_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
