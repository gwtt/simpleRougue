extends Node


var skillList:Array[BaseSkill]

const dash = preload("res://entities/skill/dash_skill/dash_skill.tscn")

func _ready() -> void:
	skillList.append(dash.instantiate())

