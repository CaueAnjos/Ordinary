extends Control

@onready var back_ground := $ColorRect

func _ready() -> void:
	$AnimationPlayer.play("GameOver_fadein")

func _on_retry_button_pressed() -> void:
	GameManager.restart_game()
