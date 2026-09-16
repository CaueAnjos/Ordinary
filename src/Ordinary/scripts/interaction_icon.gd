extends Label


func _ready() -> void:
	hide()
	GameState.nier_interaction.connect(func():
		show()
		)
	GameState.far_interaction.connect(func():
		hide()
		)
