extends Node2D
class_name TaskInteractable

@export var task_id := ""
@export var task_label := ""
@export var task_is_hidden := true
@export var is_repetable := true


@export var animation_player: AnimationPlayer
@export var animation: String
@export var exhaustion_cost := 50
@export var minigame: PackedScene

signal complete_task(task_id: String)

var _intercations_count := 0

func _on_interactable_interacted(player: Player) -> void:
	if not is_repetable and _intercations_count > 0:
		$InteractionZone.process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	_intercations_count += 1
	player.enable_input(false)
	
	animation_player.play(animation)
	await animation_player.animation_finished
	
	if minigame:
		var game = GameManager.start_minigame(minigame)
		game.failed.connect(func(): 
			GameState.exhaustion_level -= exhaustion_cost
			)
		
	player.enable_input(true)
	
	GameState.exhaustion_level += exhaustion_cost
	
	complete_task.emit(task_id)
