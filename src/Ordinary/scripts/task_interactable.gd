extends Node2D
class_name TaskInteractable

@export var task_id := ""
@export var task_label := ""
@export var task_is_hidden := true
@export var is_repetable := true
@export var task_duration := 5.0

@export var exhaustion_cost := 50
@export var minigame: PackedScene

signal complete_task(task_id: String)
signal started_task
signal ended_task

var _intercations_count := 0

func _apply_exhaustion():
	GameState.exhaustion_level += exhaustion_cost


func _end_task():
	var player := get_tree().get_first_node_in_group("Player")
	player.enable_input(true)
	complete_task.emit(task_id)
	ended_task.emit()
	print("Task ended")
	

func _on_interactable_interacted(player: Player) -> void:
	if not is_repetable and _intercations_count > 0:
		$InteractionZone.process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	print("Task started")
	started_task.emit()
	_intercations_count += 1
	player.enable_input(false)
	
	await get_tree().create_timer(task_duration).timeout
	
	if minigame:
		var game = GameManager.start_minigame(minigame)
		game.failed.connect(func():
			_end_task()
			)
		game.succeded.connect(func():
			_apply_exhaustion()
			_end_task()
			)
	else:
		_apply_exhaustion()
		_end_task()
