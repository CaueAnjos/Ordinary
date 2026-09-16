extends MinigameBase
class_name JournalMinigame

## How many wrong-slot drops are forgiven before the next one fails the
## minigame. 1 = you get one free mistake, the 2nd wrong drop fails it.
const MAX_MISTAKES := 1

@onready var drag_layer: Control = $DragLayer
@onready var word_zone: WordZone = $Visible/WordZone
@onready var word_tray: Control = $Visible/WordTray

var _mistakes := 0
var _is_ending := false


func start() -> void:
	for tile in word_tray.get_children():
		if tile is WordTile:
			tile.drag_layer = drag_layer
			tile.drop_zone = word_zone

	word_zone.all_filled.connect(_on_all_filled)
	word_zone.wrong_drop.connect(_on_wrong_drop)


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
