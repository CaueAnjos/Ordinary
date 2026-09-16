extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer

const SPEED := 120.0
var input_enabled := true
var last_direction := "down"  # remembers facing for idle animation

const DIRECTIONS := {
	"down": Vector2.DOWN,
	"up": Vector2.UP,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
}

func enable_input(enable: bool) -> void:
	input_enabled = enable

func _physics_process(delta: float) -> void:

	var direction := Vector2.ZERO

	if input_enabled:
		var direction_x := Input.get_axis("MoveLeft", "MoveRight")
		var direction_y := Input.get_axis("MoveFoward", "MoveBackward")
		direction = Vector2(direction_x, direction_y).normalized()

	_update_animation(direction)

	velocity = direction * SPEED
	GameState.player_position = position
	move_and_slide()


func _update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animation.play("PlayerIdle_" + last_direction)
		return

	var best_dot := -INF
	var best_name := last_direction

	for dir_name in DIRECTIONS:
		var dot := direction.dot(DIRECTIONS[dir_name])
		if dot > best_dot:
			best_dot = dot
			best_name = dir_name

	last_direction = best_name
	animation.play("PlayerWalk_" + best_name)
