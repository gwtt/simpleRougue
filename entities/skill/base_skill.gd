extends TextureButton
class_name BaseSkill

@export var id = 0
@export var skill_name = "" 
@export var cold_time:int 
@export var skill_image:Texture
@export_multiline var skill_information = ""

#获取技能触发的效果（被动技能主要）
func getSkill()->void:
	pass

#使用技能触发的效果
func apply()->void:
	pass
