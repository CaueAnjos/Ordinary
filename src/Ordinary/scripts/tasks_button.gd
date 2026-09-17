extends TextureButton


func _ready() -> void:
	var animation := $"../AnimationPlayer"
	
	mouse_entered.connect(func():
		animation.play("HoverPostIt")
		)
	mouse_exited.connect(func():
		animation.play("EndHoverPostIt")
		)
