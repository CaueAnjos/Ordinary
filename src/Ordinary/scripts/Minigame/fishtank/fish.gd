extends CharacterBody2D
class_name Fish


const SPEED = 220.0


func play_eat_animation() -> void:
	$AnimationPlayer.play("FishEat")



func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction > 0:
		$Sprite2D.flip_h = false
	elif direction < 0:
		$Sprite2D.flip_h = true

	velocity.y = 0
	move_and_slide()
