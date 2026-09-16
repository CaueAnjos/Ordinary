extends RigidBody2D
class_name FishFood

signal fish_touched_food
signal missed


func _on_eat_zone_body_entered(body: Node2D) -> void:
	print("Hit!")
	if body is Fish:
		print("Fish eat!")
		fish_touched_food.emit()
	else:
		print("Fish miss!")
		missed.emit()
		
	queue_free()
