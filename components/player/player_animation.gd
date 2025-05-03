class_name PlayerAnimations
extends Node

## 用来控制玩家外表的功能

signal anim_finished
@export var player: Player
@export var visual: CanvasGroup
var look_dir = null

## 调整玩家身体的动画
func anim_play(anim_name, speed = 1.0, is_back = false):
	var playing_animations = []
	
	# 收集所有需要播放动画的子节点
	for child: AnimatedSprite2D in visual.get_children():
		child.play(anim_name, speed, is_back)
		playing_animations.append(child)
	
	## 如果有动画正在播放，等待它们完成
	#if playing_animations.size() > 0:
		#await get_tree().create_timer(0.1).timeout
		#for anim in playing_animations:
			#if anim.is_playing():
				#await anim.animation_finished
		
		## 所有动画完成后发射信号
		#anim_finished.emit()

## 控制角色朝向，朝向鼠标位置看
func set_look_at(target: Vector2):
	if target != null:
		look_dir = player.global_position.direction_to(target)
		if target.x > player.position.x && visual.scale.x != 1:
			visual.scale.x = 1
		elif target.x < player.position.x && visual.scale.x != -1:
			visual.scale.x = -1
	else:
		look_dir = null
	
