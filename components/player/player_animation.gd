class_name PlayerAnimations
extends Node

## 用来控制玩家外表的功能

@export var player: Player
@export var visual: CanvasGroup
## 调整玩家身体的动画
func anim_play(anim_name, speed = 1.0, is_back = false):
	var playing_animations = []
	
	# 收集所有需要播放动画的子节点
	for child in visual.get_children():
		if child.get_class() == "AnimatedSprite2D":
			child.play(anim_name, speed, is_back)
			playing_animations.append(child)

## 控制角色朝向，朝向鼠标位置看
func set_look_at(target: Vector2):
	if target != null:
		if target.x > player.position.x && visual.scale.x != abs(visual.scale.x):
			visual.scale.x = abs(visual.scale.x)
		elif target.x < player.position.x && visual.scale.x != -abs(visual.scale.x):
			visual.scale.x = -abs(visual.scale.x)
	
