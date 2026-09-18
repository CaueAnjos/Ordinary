extends TaskInteractable

func _on_started_task() -> void:
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("ExecuteTask")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Printing")


func _on_ended_task() -> void:
	$AudioStreamPlayer.stop()
	$AnimationPlayer.stop()
