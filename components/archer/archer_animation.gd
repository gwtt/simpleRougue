class_name ArcherAnimations
extends Node

signal animation_finished
## 用来控制敌人外表的功能
@export var enemy: Archer
@onready var effect: AnimatedSprite2D = %effect
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

var completed_count = 0
var total = 0
## 调整敌人身体的动画
func anim_play(anim_name, speed = 1.0, is_back = false):
	if effect.is_connected("animation_finished", _on_child_animation_finished):
		effect.disconnect("animation_finished", _on_child_animation_finished)
	if animated_sprite_2d.is_connected("animation_finished", _on_child_animation_finished):
		animated_sprite_2d.disconnect("animation_finished", _on_child_animation_finished)
	if ["attack1","attack2"].find(anim_name) != -1:
		total = 2
		effect.play(anim_name, speed, is_back)
		effect.connect("animation_finished", _on_child_animation_finished)
		animated_sprite_2d.play(anim_name, speed, is_back)
		animated_sprite_2d.connect("animation_finished", _on_child_animation_finished)
	else:
		total = 1
		animated_sprite_2d.play(anim_name, speed, is_back)
		animated_sprite_2d.connect("animation_finished", _on_child_animation_finished)

func _on_child_animation_finished() -> void:
	completed_count += 1
	if completed_count >= total:
		animation_finished.emit()
		completed_count = 0  # 重置计数器



