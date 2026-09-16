extends Control
class_name WordZone

## Emitted once every child WordSlot has been filled correctly.
signal all_filled

## Emitted when a tile is dropped on top of a slot that doesn't accept it
## (wrong word for that slot, wrong orientation, still reversed, or the
## slot is already filled). Dropping outside every slot does NOT emit this
## - that's just a cancel.
signal wrong_drop


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


## Tries to place `tile` into whichever child WordSlot is under `global_pos`.
## Returns true (and locks the tile into the slot) only if that slot is
## empty, its expected_word_id matches the tile's word_id, the tile's
## orientation matches the slot's fixed orientation, and the tile isn't
## reversed (the solution always reads forward).
func try_drop(tile: WordTile, global_pos: Vector2) -> bool:
	for slot in _slots():
		var rect := Rect2(slot.global_position, slot.size)
		if not rect.has_point(global_pos):
			continue

		# The drop landed on this slot - either accept it or count it as
		# a mistake, but either way we're done looking at other slots.
		var is_match := (
			not slot.is_filled
			and slot.expected_word_id == tile.word_id
			and slot.is_vertical == tile.is_vertical
			and not tile.is_reversed
		)

		if not is_match:
			wrong_drop.emit()
			return false

		slot.fill(tile)
		_check_complete()
		return true

	return false


func _slots() -> Array[WordSlot]:
	var result: Array[WordSlot] = []
	for child in get_children():
		if child is WordSlot:
			result.append(child)
	return result


func _check_complete() -> void:
	for slot in _slots():
		if not slot.is_filled:
			return
	all_filled.emit()
