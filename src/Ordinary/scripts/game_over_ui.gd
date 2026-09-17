extends Control


func _ready() -> void:
	$AnimationPlayer.play("GameOver_fadein")

func _on_menu_button_pressed() -> void:
	#GameManager.go_to_main_menu()
	GameManager.restart_game()
