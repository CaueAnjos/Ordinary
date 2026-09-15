extends Node2D
class_name TaskInteractable

@export var task := ""
@export var animation_player: AnimationPlayer
@export var exhaustion_cost := 50
@export var lock_timer := 3.0

func _on_interactable_interacted(player: Player) -> void:
	player.enable_input(false)
	animation_player.play("ExecuteTask")
	await animation_player.animation_finished
	#await get_tree().create_timer(lock_timer).timeout
	player.enable_input(true)
	GameState.exhaustion_level += exhaustion_cost
	GameState.complete_task(task)
