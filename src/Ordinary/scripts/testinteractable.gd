extends Node2D

@export var disable_duration: float = 5.0

func _on_interactable_interacted(player: Player) -> void:
	print("start interaction ", GameState.exhaustion_level)
	player.enable_input(false)
	await get_tree().create_timer(disable_duration).timeout
	print("You are at: ", GameState.player_position)
	player.enable_input(true)
	GameState.exhaustion_level += 50
	print("end interaction ", GameState.exhaustion_level)
