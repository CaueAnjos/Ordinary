extends Node
class_name MyGameManager

@export var max_game_duration := 300

var is_game_over := false

enum Reason { TIMEOUT, EXHAUSTION }
var reason := Reason.EXHAUSTION

const GAME_OVER_SCENE = preload("res://scenes/UI/game_overUI.tscn")

var player: Player

func _ready() -> void:
	GameState.exhaustion_reaches_max.connect(game_over)
	GameState.completed_all_tasks.connect(game_win)
	
	player = get_tree().get_first_node_in_group("Player")


func add_ui(ui_scene: PackedScene) -> Node:
	var ui = ui_scene.instantiate()
	ui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.get_node("UI").add_child(ui)
	return ui
	
func remove_ui(ui: Node) -> void:
	get_tree().current_scene.get_node("UI").remove_child(ui)
	ui.queue_free()
	
func hide_HUD(hide: bool) -> void:
	get_tree().current_scene.get_node("UI").get_node("HUD").visible = not hide

func game_over() -> void:
	is_game_over = true
	var game_over_screen = add_ui(GAME_OVER_SCENE)
	get_tree().paused = true
	
	
func game_win() -> void:
	pass

func restart_game() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	GameState.restart_game_state()
	is_game_over = false


func start_minigame(game_scene: PackedScene) -> MinigameBase:
	get_tree().paused = true
	var game = add_ui(game_scene)
	hide_HUD(true)
	if game is MinigameBase:
		game.end.connect(func(): 
			remove_ui(game)
			hide_HUD(false)
			get_tree().paused = false
			)
	else:
		remove_ui(game)
		hide_HUD(false)
		print("minigame should be a MinigameBase")
	return game
