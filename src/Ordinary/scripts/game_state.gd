extends Node
class_name MyGameState

@export var exhaustion_max := 100
var exhaustion_level: int:
	set(value): 
		exhaustion_level = clamp(value, 0, exhaustion_max)
		if exhaustion_level >= exhaustion_max:
			exhaustion_reaches_max.emit()
	
var player_position := Vector2.ZERO

signal exhaustion_reaches_max
signal completed_task(String)
signal completed_all_tasks
signal win_game # this is dead code

@export var tasks: Dictionary[String, bool]
var completed_tasks_num := 0


func complete_task(task: String) -> void:
	tasks[task] = true
	completed_tasks_num += 1
	completed_task.emit(task)
	if completed_tasks_num >= tasks.size():
		completed_all_tasks.emit()


func restart_game_state() -> void:
	player_position = Vector2.ZERO
	completed_tasks_num = 0
	exhaustion_level = 0
	
	for task in tasks:
		tasks[task] = false
		
