extends Control
class_name WordTile

## Identifier this tile must match against a WordSlot's expected_word_id.
@export var word_id: StringName = &""

## The word's letters, always in forward (correct) reading order. Display
## order depends on is_reversed.
@export var text: String = ""

## Mutable state, toggled by the rotate/invert buttons. The solution is
## always "forward" (is_reversed = false); is_vertical must match the
## target WordSlot's own (fixed) orientation.
@export var is_vertical: bool = false
@export var is_reversed: bool = false

@export var tile_color: Color = Color(0.9, 0.85, 0.7)

const CELL_SIZE := 16
const RETURN_DURATION := 0.25
const BUTTON_SIZE := 12
const BUTTON_GAP := 2
const FOLLOW_SMOOTHING := 22.0

## Assigned by the minigame at start() so the tile knows where to render
## itself while dragged and who to ask when it's dropped.
var drag_layer: Control
var drop_zone: WordZone

var _dragging := false
var _locked := false
var _drag_offset := Vector2.ZERO
var _origin_parent: Node
var _origin_position := Vector2.ZERO
var _origin_index := -1

var _letter_labels: Array[Label] = []

@onready var background: ColorRect = $Background
@onready var toolbar: Control = $Toolbar
@onready var rotate_button: Button = $Toolbar/RotateButton
@onready var invert_button: Button = $Toolbar/InvertButton


func _ready() -> void:
	# Don't rely on inherited process_mode timing from the minigame root -
	# minigames run with the SceneTree paused.
	process_mode = Node.PROCESS_MODE_ALWAYS

	background.color = tile_color
	rotate_button.pressed.connect(_on_rotate_pressed)
	invert_button.pressed.connect(_on_invert_pressed)

	_relayout()


func _on_rotate_pressed() -> void:
	if _locked:
		return
	is_vertical = not is_vertical
	_relayout()


func _on_invert_pressed() -> void:
	if _locked:
		return
	is_reversed = not is_reversed
	_relayout()


## Rebuilds the per-letter Labels according to the current orientation and
## direction, and resizes the tile to match.
func _relayout() -> void:
	for lbl in _letter_labels:
		lbl.queue_free()
	_letter_labels.clear()

	var display_text := _reverse_string(text) if is_reversed else text

	for i in range(display_text.length()):
		var lbl := Label.new()
		lbl.text = display_text[i]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color", Color(0.2, 0.15, 0.1))
		lbl.size = Vector2(CELL_SIZE, CELL_SIZE)
		lbl.position = Vector2(0, i * CELL_SIZE) if is_vertical else Vector2(i * CELL_SIZE, 0)
		add_child(lbl)
		_letter_labels.append(lbl)

	var length := maxi(display_text.length(), 1)
	size = Vector2(CELL_SIZE, length * CELL_SIZE) if is_vertical else Vector2(length * CELL_SIZE, CELL_SIZE)
	background.size = size

	toolbar.position = Vector2(0, -BUTTON_SIZE - BUTTON_GAP)


func _reverse_string(s: String) -> String:
	var result := ""
	for i in range(s.length() - 1, -1, -1):
		result += s[i]
	return result


## Picking the tile up: only fires when the click actually lands on it
## (Control hit-testing), and only while it's not already being dragged.
func _gui_input(event: InputEvent) -> void:
	if _locked or _dragging:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		_start_drag()
		accept_event()


## Dropping the tile: this is a toggle, not a hold. Once dragging, the
## *next* left click anywhere on screen drops it - unlike _gui_input, Node's
## _input() fires for every click regardless of what's under the cursor.
## Clicks on a Button (e.g. this or any other tile's rotate/invert buttons)
## are ignored here so they can still be pressed while a tile is dragging.
func _input(event: InputEvent) -> void:
	if not _dragging:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if get_viewport().gui_get_hovered_control() is BaseButton:
			return

		_end_drag()
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if not _dragging:
		return

	var target := get_global_mouse_position() - _drag_offset
	var weight := clampf(FOLLOW_SMOOTHING * delta, 0.0, 1.0)
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


## Called by WordSlot once it accepts this tile. Disables further dragging
## and rotating/inverting.
func lock_in_place() -> void:
	_locked = true
	_dragging = false
	toolbar.visible = false
