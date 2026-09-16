extends Control
class_name MinigameBase

signal succeded
signal failed
signal end

func _ready() -> void:
	$AnimationPlayer.play("StartMinigame")
	await $AnimationPlayer.animation_finished
	start()


# should be overrided
func start() -> void:
	pass
