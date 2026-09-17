extends Control


func _ready() -> void:
	var tip := $VisibleElements/Tip
	
	match GameManager.reason:
		GameManager.Reason.TIMEOUT:
			tip.text = "Você precisa ser mais rápido!"
		GameManager.Reason.EXHAUSTION:
			tip.text = "Você tentou descançar?
			Explore o mapa"
		
			
	$AnimationPlayer.play("GameOver_fadein")

func _on_retry_button_pressed() -> void:
	GameManager.restart_game()
