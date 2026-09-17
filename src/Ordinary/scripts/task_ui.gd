extends Control
class_name TaskItem

@export var checked_texture: Texture2D
@export var unchecked_texture: Texture2D

## Text/checkbox colors for a pending (not yet completed) task. Kept vivid to draw attention.
@export var pending_text_color: Color = Color(0.9215686, 0.9215686, 0.9215686, 1)
@export var pending_checkbox_color: Color = Color(0.78431374, 0.43529412, 0.5176471, 1)

## Text/checkbox colors for a completed task. Muted/desaturated so it visually recedes.
@export var completed_text_color: Color = Color(0.5, 0.5, 0.5, 0.75)
@export var completed_checkbox_color: Color = Color(0.5, 0.54, 0.47, 0.85)

@onready var checkbox: TextureRect = $Checkbox
@onready var label: Label = $Label

var text: String
var is_checked := false

func _ready() -> void:
	label.text = text
	_update_style()

func mark_as_complete(complete: bool) -> void:
	is_checked = complete
	_update_style()

func _update_style() -> void:
	checkbox.texture = checked_texture if is_checked else unchecked_texture
	checkbox.modulate = completed_checkbox_color if is_checked else pending_checkbox_color
	label.modulate = completed_text_color if is_checked else pending_text_color
