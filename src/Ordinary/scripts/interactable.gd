extends Node
class_name Interactable

@export var interactable_area: Area2D

var player_is_inside: bool
var player: Player

signal interacted(player: Player)

func _ready() -> void:
	interactable_area.body_entered.connect(_on_interactable_area_entered)
	interactable_area.body_exited.connect(_on_interactable_area_exited)

func _on_interactable_area_entered(body) -> void:
	if body.is_in_group("Player") and body is Player:
		player_is_inside = true
		GameState.can_interact = true
		player = body
		print("Player is inside interactable area")
	
func _on_interactable_area_exited(body) -> void:
	if body.is_in_group("Player") and body is Player:
		player_is_inside = false
		GameState.can_interact = false
		player = null
		print("Player exited interactable area")
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_is_inside:
		interacted.emit(player)
