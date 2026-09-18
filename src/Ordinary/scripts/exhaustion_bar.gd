extends ProgressBar

#70ae00
#ff6352

@export var fill_good: Color
@export var fill_bad: Color


func calculate(exhaustion_level: int) -> float:
	var value = float(exhaustion_level) / float(GameState.exhaustion_max)
	print(value)
	return value


func _ready() -> void:
	value = calculate(GameState.exhaustion_level)
	var style = get_theme_stylebox("fill")
	style.bg_color = fill_bad.lerp(fill_good, value)
	
	GameState.exhaustion_changes.connect(func(exhaustion_level: int):
		value = calculate(exhaustion_level)
		style.bg_color = fill_bad.lerp(fill_good, value)
		)
