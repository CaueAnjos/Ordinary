extends Control

## The scene loaded when the Start button is pressed. Change this in the Inspector
## to point "Start" at a different scene/level.
@export var scene_to_load: PackedScene = preload("res://scenes/maps/game_map.tscn")

@onready var menu_view: Control = $MenuView
@onready var credits_view: Control = $CreditsView
@onready var credits_animation: AnimationPlayer = $CreditsView/AnimationPlayer


func _ready() -> void:
	menu_view.visible = true
	credits_view.visible = false


func _on_start_button_pressed() -> void:
	GameManager.load_scene(scene_to_load)


func _on_credits_button_pressed() -> void:
	menu_view.visible = false
	credits_view.visible = true
	credits_animation.play("credits_scroll")


func _on_back_button_pressed() -> void:
	credits_animation.stop()
	credits_view.visible = false
	menu_view.visible = true
