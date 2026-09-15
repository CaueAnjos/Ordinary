extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $Sprite2D

const SPEED := 300.0
var input_enabled := true

func enable_input(enable: bool) -> void:
	input_enabled = enable

func _physics_process(delta: float) -> void:
	
	var direction := Vector2.ZERO
	
	if input_enabled:
		var direction_x := Input.get_axis("MoveLeft", "MoveRight")
		var direction_y := Input.get_axis("MoveFoward", "MoveBackward")
		direction = Vector2(direction_x, direction_y).normalized()
		
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	velocity = direction * SPEED
	GameState.player_position = position
	move_and_slide()
