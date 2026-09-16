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


func start_minigame(game_scene: PackedScene) -> MinigameBase:
	get_tree().paused = true
	var game = game_scene.instantiate()
	if game is MinigameBase:
		get_tree().current_scene.get_node("UI").add_child(game)
		get_tree().current_scene.get_node("UI").get_node("HUD").hide()
		game.process_mode = Node.PROCESS_MODE_ALWAYS
		game.start()
		game.end.connect(func(): 
			get_tree().current_scene.get_node("UI").remove_child(game)
			get_tree().current_scene.get_node("UI").get_node("HUD").show()
			get_tree().paused = false
			)
	else:
		print("minigame should be a MinigameBase")
	return game
