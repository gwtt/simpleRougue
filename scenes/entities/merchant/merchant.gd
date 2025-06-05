extends AnimatedSprite2D

@onready var raffle = preload("res://data/dialogue/抽奖.dialogue")
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("e"):
		DialogueManager.show_dialogue_balloon(raffle, "start")
		Utils.cross_hair_change(false)

func _on_area_2d_area_entered(area: Area2D) -> void:
	animation_player.play("!move")


func _on_area_2d_area_exited(area: Area2D) -> void:
	animation_player.stop()
	sprite_2d.modulate = Color(0, 0, 0, 0)
