extends MinigameBase
class_name CoffeeMinigame

## How many wrong-slot drops are forgiven before the next one fails the
## minigame. 1 = you get one free mistake, the 2nd wrong drop fails it.
const MAX_MISTAKES := 1

@onready var drag_layer: Control = $DragLayer
@onready var drop_zone: DropZone = $Visible/CoffeMaker/DropZone
@onready var items_tray: Control = $Visible/ItemsTray

var _mistakes := 0
var _is_ending := false

func start() -> void:
	for item in items_tray.get_children():
		if item is DraggableItem:
			item.drag_layer = drag_layer
			item.drop_zone = drop_zone

	drop_zone.all_filled.connect(_on_all_filled)
	drop_zone.wrong_drop.connect(_on_wrong_drop)


func _on_all_filled() -> void:
	if _is_ending:
		return
	succeded.emit()
	end_minigame()


func _on_wrong_drop() -> void:
	if _is_ending:
		return

	_mistakes += 1
	if _mistakes > MAX_MISTAKES:
		failed.emit()
		end_minigame()


func end_minigame() -> void:
	_is_ending = true
	$AnimationPlayer.play("EndMinigame")
	await $AnimationPlayer.animation_finished
	end.emit()
