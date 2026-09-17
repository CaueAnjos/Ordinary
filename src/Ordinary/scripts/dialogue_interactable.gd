extends StaticBody2D
class_name DialogueInteractable
## A simple interactable that shows a dialogue balloon when the player interacts with it.


## The dialogue resource to show when interacted with.
@export var dialogue: DialogueResource

## The title/cue to start the dialogue from. Leave empty to start from the top of the file.
@export var start_title: String = ""


func _on_interactable_interacted(_player: Player) -> void:
	if not is_instance_valid(dialogue):
		push_warning("DialogueInteractable '%s' has no dialogue resource assigned." % name)
		return

	DialogueManager.show_dialogue_balloon(dialogue, start_title)
