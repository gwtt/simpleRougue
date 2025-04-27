class_name PlayerSkill
extends Node

## 用来实现玩家的技能效果
@export var player: Player
@export var ghost_node: PackedScene
@export var visuals: CanvasGroup
## 调整玩家身体的动画

func dash():
	## 0.05秒造一个幻影
	for i in range(5):
		await get_tree().create_timer(0.05).timeout
		var ghost: Ghost = ghost_node.instantiate()
		ghost.set_property(player.global_position, visuals, visuals.scale)
		get_parent().add_child(ghost)
	player.stateSendEvent("to_not_dash")

