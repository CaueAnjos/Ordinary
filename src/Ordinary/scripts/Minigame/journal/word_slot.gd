extends Control
class_name WordSlot

## Only a WordTile with a matching word_id will be accepted here.
@export var expected_word_id: StringName = &""

## Fixed orientation of this slot - never changes, it's part of the puzzle
## structure. The tile must be rotated to match this.
@export var is_vertical: bool = false

## Number of letters, used only to draw that many blank ghost cells.
@export var length: int = 3

const CELL_SIZE := 16
const FILL_DURATION := 0.2

var is_filled := false


func _ready() -> void:
	# Minigames run with the SceneTree paused; don't rely on inherited
	# process_mode timing from the minigame root.
	process_mode = Node.PROCESS_MODE_ALWAYS

	_build_ghost_cells()


func _build_ghost_cells() -> void:
	for i in range(length):
		var cell := ColorRect.new()
		cell.color = Color(0.9, 0.85, 0.7, 0.25)
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cell.size = Vector2(CELL_SIZE, CELL_SIZE)
		cell.position = Vector2(0, i * CELL_SIZE) if is_vertical else Vector2(i * CELL_SIZE, 0)
		add_child(cell)

	var count := maxi(length, 1)
	size = Vector2(CELL_SIZE, count * CELL_SIZE) if is_vertical else Vector2(count * CELL_SIZE, CELL_SIZE)


## Reparents/centers the tile inside this slot and locks it in place.
## Called by WordZone once it has verified the tile is a valid match.
func fill(tile: WordTile) -> void:
	is_filled = true

	var current_global := tile.global_position
	var parent := tile.get_parent()
	if parent != self:
		parent.remove_child(tile)
		add_child(tile)
		tile.global_position = current_global

	var tween := create_tween()
	tween.tween_property(tile, "position", Vector2.ZERO, FILL_DURATION) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tile.lock_in_place()
