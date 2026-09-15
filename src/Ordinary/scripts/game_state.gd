extends Node
class_name MyGameState

@export var exhaustion_max := 100
var exhaustion_level: int:
	set(value): 
		exhaustion_level = clamp(value, 0, exhaustion_max)
		if exhaustion_level >= exhaustion_max:
			exhaustion_reaches_max.emit()
	
var player_position := Vector2.ZERO

signal exhaustion_reaches_max


func _on_exhaustion_reaches_max() -> void:
	print("Game over! You are Exhausted")
