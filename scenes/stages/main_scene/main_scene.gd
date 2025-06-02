extends Node2D
@onready var r = preload("res://data/dialogue/抽奖.dialogue")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		DialogueManager.show_dialogue_balloon(r, "start")
