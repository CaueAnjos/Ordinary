extends Control
class_name TaskItem

@export var checked_texture: Texture2D
@export var unchecked_texture: Texture2D

@onready var checkbox: TextureRect = $Checkbox
@onready var label: Label = $Label

var text: String
var is_checked := false

func _ready() -> void:
	label.text = text

func mark_as_complete(complete: bool) -> void:
	is_checked = complete
	checkbox.texture = checked_texture if is_checked else unchecked_texture
