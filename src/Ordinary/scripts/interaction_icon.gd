extends Label


func _ready() -> void:
	hide()
	GameState.nier_interaction.connect(func():
		show()
		)
	GameState.far_interaction.connect(func():
		hide()
		)


func _on_tasks_button_mouse_entered() -> void:
	pass # Replace with function body.
