extends Node2D
class_name TaskInteractable

@export var task := ""
@export var animation_player: AnimationPlayer
@export var animation: String
@export var exhaustion_cost := 50
@export var minigame: PackedScene

func _on_interactable_interacted(player: Player) -> void:
	player.enable_input(false)
	
	animation_player.play(animation)
	await animation_player.animation_finished
	
	var should_apply_exhaustion := true
	
	if minigame:
		print("minigame started")
		var game = GameManager.start_minigame(minigame)
		game.failed.connect(func(): 
			should_apply_exhaustion = false
			)
		
	player.enable_input(true)
	
	GameState.exhaustion_level += exhaustion_cost
	print("")
	
	if not task.is_empty():
		GameState.complete_task(task)
