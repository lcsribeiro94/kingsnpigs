extends Control

@onready var main_menu = $MainMenu
@onready var credits_screen = $CreditsScreen

func _on_btn_start_pressed():
	# start the game
	get_tree().change_scene_to_file("res://levels/game.tscn")
	pass # Replace with function body.


func _on_btn_options_pressed():
	# obscure main menu
	# bring the options menu
	# after confirm or cancel, hide options menu and reveals main menu
	pass # Replace with function body.


func _on_btn_credits_pressed():
	# obscure main menu
	main_menu.visible = false
	# bring the credits screen
	credits_screen.visible = true
	# after back, hide credits screen and reveals main menu
	pass # Replace with function body.


func _on_btn_quit_pressed():
	# simply quit the game
	get_tree().quit()
	pass # Replace with function body.


func _on_btn_close_credits_pressed():
	# fechar créditos
	credits_screen.visible = false
	main_menu.visible = true
	pass # Replace with function body.
