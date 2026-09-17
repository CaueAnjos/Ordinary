extends Control

## The VBoxContainer that holds the individual TaskItem rows inside the popup panel.
@export var tasks_container: VBoxContainer

## Delay between each task row's staggered reveal animation, in seconds.
@export var stagger_delay: float = 0.06

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tasks: Dictionary[String, TaskItem]
var is_open := false

const TASK_ITEM_SCENE = preload("res://scenes/UI/taskUI.tscn")


func create_task_item(id: String, label: String) -> void:
	if tasks.has(id):
		return

	var task: TaskItem = TASK_ITEM_SCENE.instantiate()
	task.text = label
	tasks[id] = task
	tasks_container.add_child(task)

	# If the popup is already open when a new task shows up, animate it in immediately.
	if is_open:
		_animate_item_in(task, 0.0)


func _ready() -> void:
	var container := get_tree().get_first_node_in_group("TasksContainer")
	if container is TasksContainer:
		container.complete_task.connect(_on_completed_task)
		container.unhided_task.connect(_on_unhided_task)

		for id in container.tasks:
			if container.tasks[id].hidden:
				continue

			var label = container.tasks[id].label
			create_task_item(id, label)


## Opens the popup if it's closed, or closes it if it's open.
func toggle() -> void:
	if is_open:
		close()
	else:
		open()


## Shows the task list popup, freezing player movement and playing the reveal animation.
func open() -> void:
	if is_open:
		return
	is_open = true

	get_tree().get_first_node_in_group("Player").enable_input(false)

	animation_player.play("popup_open")
	await animation_player.animation_finished
	_reveal_all_items()


## Hides the task list popup and gives movement control back to the player.
func close() -> void:
	if not is_open:
		return
	is_open = false

	get_tree().get_first_node_in_group("Player").enable_input(true)

	animation_player.play_backwards("popup_open")


# Plays a cascading fade + slide-in animation for every current task row.
func _reveal_all_items() -> void:
	var rows := tasks_container.get_children()
	for i in rows.size():
		_animate_item_in(rows[i], i * stagger_delay)


# Fades and slides a single task row into place, optionally after a delay.
func _animate_item_in(row, delay: float) -> void:
	var target_x = row.position.x
	row.modulate.a = 0.0
	row.position.x = target_x - 12.0

	var tween := create_tween()
	tween.tween_interval(delay)
	tween.tween_property(row, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(row, "position:x", target_x, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_unhided_task(id: String) -> void:
	var container := get_tree().get_first_node_in_group("TasksContainer")
	if container is TasksContainer:
		var label = container.tasks[id].label
		create_task_item(id, label)


func _on_completed_task(id: String) -> void:
	if tasks.has(id):
		tasks[id].mark_as_complete(true)
	else:
		print("For somereason, this task doesn't exists on the UI")
