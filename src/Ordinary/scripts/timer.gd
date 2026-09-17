extends Control


var _time := 0.0
var _minutes := 0
var _seconds := 0
var _msecs := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	if GameManager.is_game_over:
		return
	
	_time += delta
	if _time >= GameManager.max_game_duration:
		GameManager.reason = GameManager.Reason.TIMEOUT
		GameManager.game_over()
	
	_msecs = fmod(_time, 1) * 100
	_seconds = fmod(_time, 60)
	_minutes = fmod(_time, 3600) /60
	$Minutes.text = "%02d:" % _minutes
	$Seconds.text = "%02d:" % _seconds
	$Msecs.text = "%02d:" % _msecs
