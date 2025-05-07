class_name OrcAnimations
extends Node

## 用来控制敌人外表的功能
@export var enemy: Orc
@export var visual: Node2D

## 调整敌人身体的动画
func anim_play(anim_name, speed = 1.0, is_back = false):
	var playing_animations = []
	
	# 收集所有需要播放动画的子节点
	for child: AnimatedSprite2D in visual.get_children():
		child.play(anim_name, speed, is_back)
		playing_animations.append(child)

## 控制敌人朝向，朝向目标位置看
func set_look_at(target: Vector2):
	if target != null:
		if target.x > enemy.position.x && visual.scale.x != abs(visual.scale.x):
			visual.scale.x = abs(visual.scale.x)
		elif target.x < enemy.position.x && visual.scale.x != -abs(visual.scale.x):
			visual.scale.x = -abs(visual.scale.x)
	
