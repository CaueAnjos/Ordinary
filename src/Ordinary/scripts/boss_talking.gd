extends StaticBody2D


@export var give_tasks_dialogue: DialogueResource
@export var task_id: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var counts_talking := 0

func _on_interactable_interacted(player: Player) -> void:
	var cue := "firstTime"
	if counts_talking > 0:
		cue = "anyTime"
	else:
		
		
		var tasks_container = get_tree().get_first_node_in_group("TasksContainer")
		tasks_container.mark_task_as_complete(task_id)
	
	counts_talking += 1
	animation_player.play("BossTalking")
	var balloon := DialogueManager.show_dialogue_balloon(give_tasks_dialogue, cue)
	balloon.tree_exited.connect(_on_dialogue_balloon_closed)


func _on_dialogue_balloon_closed() -> void:
	animation_player.play("RESET")
