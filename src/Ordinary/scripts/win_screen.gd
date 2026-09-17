extends Control


func _ready() -> void:
	$AnimationPlayer.play("WinScreen_fadein")


func _on_menu_button_pressed() -> void:
	GameManager.go_to_main_menu()
