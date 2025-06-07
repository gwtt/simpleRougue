extends AnimatedSprite2D

@onready var raffle = preload("res://data/dialogue/抽奖.dialogue")
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D
var local_pos = Vector2(0, -50)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("e"):
		var dialogue = DialogueManager.show_dialogue_balloon(raffle, "start")
		await dialogue.ready
		dialogue.balloon.position = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * local_pos
		Utils.cross_hair_change(false)
		
func _on_area_2d_area_entered(_area: Area2D) -> void:
	animation_player.play("!move")


func _on_area_2d_area_exited(_area: Area2D) -> void:
	animation_player.stop()
	sprite_2d.modulate = Color(0, 0, 0, 0)
