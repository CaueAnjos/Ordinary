extends Control
class_name DraggableItem

## Identifier this item must match against a DropSlot's required_item_id.
@export var item_id: StringName = &""

@export var display_name: String = "":
	set(value):
		display_name = value
		if label:
			label.text = value

## Tint applied to the item's icon texture. Defaults to white (no tint).
@export var color: Color = Color.WHITE:
	set(value):
		color = value
		if icon:
			icon.modulate = value

## How quickly the item catches up to the cursor while dragging. Higher =
## snappier/stiffer, lower = smoother/laggier follow.
@export var follow_smoothing := 22.0

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label

const RETURN_DURATION := 0.25

## Assigned by the minigame at start() so the item knows where to render
## itself while dragged and who to ask when it's dropped.
var drag_layer: Control
var drop_zone: DropZone

var _dragging := false
var _locked := false
var _drag_offset := Vector2.ZERO
var _origin_parent: Node
var _origin_position := Vector2.ZERO
var _origin_index := -1


func _ready() -> void:
	# Don't rely on inherited process_mode timing from the minigame root -
	# make sure this item keeps processing/receiving input even while the
	# SceneTree is paused (minigames run with the tree paused).
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Re-apply exported values now that the child nodes exist.
	label.text = display_name
	icon.modulate = color


## Picking the item up: only fires when the click actually lands on this
## item (Control hit-testing), and only while it's not already being dragged.
func _gui_input(event: InputEvent) -> void:
	if _locked or _dragging:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_start_drag()
		accept_event()


## Dropping the item: this is a toggle, not a hold. Once dragging, the
## *next* left click anywhere on screen drops it - unlike _gui_input, Node's
## _input() fires for every click regardless of what's under the cursor.
func _input(event: InputEvent) -> void:
	if not _dragging:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_end_drag()
		# Consume it so this same click can't also be picked up as a fresh
		# "grab" on whatever item happens to be under the cursor at the
		# drop location.
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if not _dragging:
		return

	var target := get_global_mouse_position() - _drag_offset
	var weight := clampf(follow_smoothing * delta, 0.0, 1.0)
	global_position = global_position.lerp(target, weight)


func _start_drag() -> void:
	_dragging = true
	_drag_offset = get_global_mouse_position() - global_position
	_origin_parent = get_parent()
	_origin_position = position
	_origin_index = get_index()

	if drag_layer and _origin_parent != drag_layer:
		var current_global := global_position
		_origin_parent.remove_child(self)
		drag_layer.add_child(self)
		global_position = current_global

	move_to_front()


func _end_drag() -> void:
	_dragging = false

	var accepted := false
	if drop_zone:
		accepted = drop_zone.try_drop(self, get_global_mouse_position())

	if not accepted:
		_return_to_origin()


func _return_to_origin() -> void:
	var current_global := global_position
	var current_parent := get_parent()

	if current_parent != _origin_parent:
		current_parent.remove_child(self)
		_origin_parent.add_child(self)
		_origin_parent.move_child(self, _origin_index)
		global_position = current_global

	var tween := create_tween()
	tween.tween_property(self, "position", _origin_position, RETURN_DURATION) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Called by DropSlot once it accepts this item. Disables further dragging.
func lock_in_place() -> void:
	_locked = true
	_dragging = false
