extends StaticBody2D


@export var give_tasks_dialogue: DialogueResource
@export var task_id: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var counts_talking := 0

func _on_interactable_interacted(player: Player) -> void:
	var tasks_container = get_tree().get_first_node_in_group("TasksContainer")
	var cue := "anyTime"
	var finishing_game := false

	if counts_talking == 0:
		cue = "firstTime"
		tasks_container.mark_task_as_complete(task_id)
	elif GameState.all_tasks_completed and tasks_container.tasks.has(TasksContainer.FINAL_TASK_ID) and not tasks_container.tasks[TasksContainer.FINAL_TASK_ID].completed:
		cue = "allTasksComplete"
		finishing_game = true

	counts_talking += 1
	animation_player.play("BossTalking")
	var balloon := DialogueManager.show_dialogue_balloon(give_tasks_dialogue, cue)
	balloon.tree_exited.connect(_on_dialogue_balloon_closed.bind(tasks_container, finishing_game))


# Only mark the final task (and therefore trigger the win screen) once the
# player has actually finished reading/closing the "all tasks complete" dialogue.
func _on_dialogue_balloon_closed(tasks_container, finishing_game: bool) -> void:
	animation_player.play("RESET")
	if finishing_game:
		tasks_container.mark_task_as_complete(TasksContainer.FINAL_TASK_ID)
