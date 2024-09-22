extends Node
class_name BaseSkill

@export var 技能ID = 0
@export var 技能名称 = "" 
@export var 冷却时间:int 
@export var 技能图片:Texture
@export_multiline var 技能信息 = ""

#获取技能触发的效果（被动技能主要）
func getSkill()->void:
	pass

#使用技能触发的效果
func apply()->void:
	pass
