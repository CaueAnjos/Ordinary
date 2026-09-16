extends Control
class_name DropSlot

## Only a DraggableItem with a matching item_id will be accepted here.
@export var required_item_id: StringName = &""

const FILL_DURATION := 0.2

var is_filled := false


func _ready() -> void:
	# Minigames run with the SceneTree paused; don't rely on inherited
	# process_mode timing from the minigame root.
	process_mode = Node.PROCESS_MODE_ALWAYS


## Reparents/centers the item inside this slot and locks it in place.
## Called by DropZone once it has verified the item is a valid match.
func fill(item: DraggableItem) -> void:
	is_filled = true

	var current_global := item.global_position
	var parent := item.get_parent()
	if parent != self:
		parent.remove_child(item)
		add_child(item)
		item.global_position = current_global

	var target := (size - item.size) * 0.5
	var tween := create_tween()
	tween.tween_property(item, "position", target, FILL_DURATION) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	item.lock_in_place()
