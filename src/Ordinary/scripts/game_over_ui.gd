extends Control


func _ready() -> void:
	$AnimationPlayer.play("GameOver_fadein")

func _on_retry_button_pressed() -> void:
	GameManager.restart_game()
