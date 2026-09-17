extends StaticBody2D


@export var boss_dialog: PackedScene


func _on_interactable_interacted(player: Player) -> void:
	return
	GameManager.add_ui(boss_dialog)
	GameManager.hide_HUD(true)
	GameManager.player.enable_input(false)
