extends Node
class_name MyGameManager

const GAME_OVER_SCENE = preload("res://scenes/UI/game_overUI.tscn")

func _ready() -> void:
	GameState.exhaustion_reaches_max.connect(game_over)
	GameState.completed_all_tasks.connect(game_win)

func game_over() -> void:
	var game_over_screen = GAME_OVER_SCENE.instantiate()
	get_tree().current_scene.add_child(game_over_screen)
	
func game_win() -> void:
	pass

func restart_game() -> void:
	get_tree().reload_current_scene()
	
