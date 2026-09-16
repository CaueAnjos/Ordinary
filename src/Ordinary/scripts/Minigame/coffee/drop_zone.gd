extends Control
class_name DropZone

## Emitted once every child DropSlot has been filled correctly.
signal all_filled

## Emitted when an item is dropped on top of a slot that doesn't accept it
## (wrong item for that slot, or the slot is already filled). Dropping
## outside every slot does NOT emit this - that's just a cancel.
signal wrong_drop


func _ready() -> void:
	# Minigames run with the SceneTree paused; don't rely on inherited
	# process_mode timing from the minigame root.
	process_mode = Node.PROCESS_MODE_ALWAYS


## Tries to place `item` into whichever child DropSlot is under `global_pos`.
## Returns true (and locks the item into the slot) only if that slot is
## empty and its required_item_id matches the item's id.
func try_drop(item: DraggableItem, global_pos: Vector2) -> bool:
	for slot in _slots():
		var rect := Rect2(slot.global_position, slot.size)
		if not rect.has_point(global_pos):
			continue

		# The drop landed on this slot - either accept it or count it as
		# a mistake, but either way we're done looking at other slots.
		if slot.is_filled or slot.required_item_id != item.item_id:
			wrong_drop.emit()
			return false

		slot.fill(item)
		_check_complete()
		return true

	return false


func _slots() -> Array[DropSlot]:
	var result: Array[DropSlot] = []
	for child in get_children():
		if child is DropSlot:
			result.append(child)
	return result


func _check_complete() -> void:
	for slot in _slots():
		if not slot.is_filled:
			return
	all_filled.emit()
