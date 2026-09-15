extends Node
class_name MyGameManager

const GAME_OVER_SCENE = preload("res://scenes/UI/game_overUI.tscn")

func _ready() -> void:
	GameState.exhaustion_reaches_max.connect(game_over)
	GameState.completed_all_tasks.connect(game_win)

func game_over() -> void:
	var game_over_screen = GAME_OVER_SCENE.instantiate()
	game_over_screen.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().current_scene.get_node("UI").add_child(game_over_screen)
	get_tree().paused = true
	
	
func game_win() -> void:
	pass

func restart_game() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	GameState.restart_game_state()
	
