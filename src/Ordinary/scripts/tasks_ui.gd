extends Control

@export var tasks_container: VBoxContainer

var tasks: Dictionary[String, TaskItem]
const TASK_ITEM_SCENE = preload("res://scenes/UI/taskUI.tscn")


func create_task_item(id: String, label: String):
	if tasks.has(id):
		return
	
	var task = TASK_ITEM_SCENE.instantiate()
	task.text = label
	tasks[id] = task
	$TasksContainer.add_child(task)


func _ready() -> void:
	var tasks_container = get_tree().get_first_node_in_group("TasksContainer")
	if tasks_container is TasksContainer:
		tasks_container.complete_task.connect(_on_completed_task)
		tasks_container.unhided_task.connect(_on_unhided_task)
		
		for id in tasks_container.tasks:
			if tasks_container.tasks[id].hidden:
				continue
			
			var label = tasks_container.tasks[id].label
			create_task_item(id, label)


func _on_unhided_task(id: String):
	var tasks_container = get_tree().get_first_node_in_group("TasksContainer")
	if tasks_container is TasksContainer:
		var label = tasks_container.tasks[id].label
		create_task_item(id, label)

func _on_completed_task(id: String):
	if tasks.has(id):
		tasks[id].mark_as_complete(true)
	else:
		print("For somereason, this task doesn't exists on the UI")
