extends Control

@export var tasks_container: VBoxContainer

var tasks: Dictionary[String, TaskItem]
const TASK_ITEM_SCENE = preload("res://scenes/UI/taskUI.tscn")

func _ready() -> void:
	GameState.completed_task.connect(_on_completed_task)
	
	var labels = GameState.tasks.keys()
	for label in labels:
		var task = TASK_ITEM_SCENE.instantiate()
		task.text = label
		tasks[label] = task
		tasks_container.add_child(task)


func _on_completed_task(task: String):
	if tasks.has(task):
		tasks[task].mark_as_complete(true)
	else:
		print("For somereason, this task doesn't exists on the UI")
