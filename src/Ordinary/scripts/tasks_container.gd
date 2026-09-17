extends Node
class_name TasksContainer

class Task:
	var id: String
	var label: String
	var completed: bool
	var hidden: bool


@export var extra_tasks: Dictionary[String, String]


var _tasks_interactables: Array[TaskInteractable]
var tasks: Dictionary[String, Task]


signal complete_any_task
signal complete_task(task_id: String)
signal unhided_task(task_id: String)


func mark_task_as_complete(id: String):
	if not tasks.has(id):
		return
		
	if tasks[id].hidden:
		return
	
	tasks[id].completed = true
	complete_any_task.emit()
	complete_task.emit(id)


func unhide_all_tasks() -> void:
	for id in tasks:
		tasks[id].hidden = false
		unhided_task.emit(id)


func unhide_tasks(tasks_ids: Array, hidden: bool) -> void:
	for id in tasks_ids:
		if tasks.has(id):
			tasks[id].hidden = hidden
			unhided_task.emit(id)


func _on_complete_task(id: String) -> void:
	mark_task_as_complete(id)
	GameState.completed_tasks_num += 1


func _ready() -> void:
	for id in extra_tasks:
		var task = Task.new()
		task.id = id
		task.label = extra_tasks[id]
		task.completed = false
		task.hidden = false
		tasks[id] = task
	
	for child in get_children():
		if child is TaskInteractable:
			if child.task_id.is_empty():
				continue
			
			_tasks_interactables.append(child)
			child.complete_task.connect(_on_complete_task)
			
			var task := Task.new()
			task.id = child.task_id
			task.label = child.task_label
			task.completed = false
			task.hidden = child.task_is_hidden
			tasks[task.id] = task
	
	print(tasks)
