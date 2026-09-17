extends StaticBody2D


@export var give_tasks_dialogue: DialogueResource

var counts_talking := 0

func _on_interactable_interacted(player: Player) -> void:
	var cue := "firstTime"
	if counts_talking > 0:
		cue = "anyTime"
	
	counts_talking += 1
	DialogueManager.show_dialogue_balloon(give_tasks_dialogue, cue)
