extends MinigameBase

@export var num_foods_to_eat: int
@export var max_foods_to_miss: int

@export var food_scene: PackedScene
@export var hight: float
@export var max_right: float
@export var max_left: float

var _foods_eaten := 0
var _foods_missed := 0
var _is_ending := false

func start() -> void:
	PhysicsServer2D.set_active(true)

func check_end_game() -> void:
	if _is_ending:
		return
	
	if _foods_eaten >= num_foods_to_eat:
		succeded.emit()
		end_minigame()
	elif _foods_missed >= max_foods_to_miss:
		failed.emit()
		end_minigame()

func _on_spawn_food_timer_timeout() -> void:
	print("timeout")
	var food = food_scene.instantiate()
	if food is FishFood:
		food.position.y = hight
		food.position.x = randf_range(max_left, max_right)
		add_child(food)
		food.process_mode = Node.PROCESS_MODE_ALWAYS
		
		food.fish_touched_food.connect(func():
			_foods_eaten += 1
			$Visible/Fish.play_eat_animation()
			check_end_game()
			)
		food.missed.connect(func():
			_foods_missed += 1
			check_end_game()
			)


func end_minigame() -> void:
	_is_ending = true
	PhysicsServer2D.set_active(false)
	$SpawnFoodTimer.stop()
	$AnimationPlayer.play("EndMinigame")
	await $AnimationPlayer.animation_finished
	end.emit()
	
