extends Node

#冲锋信号触发
signal onDash()

var skillList:Array[BaseSkill]

const dash = preload("res://entities/skill/dash_skill/dash_skill.tscn")

func _ready() -> void:
	skillList.append(dash.instantiate())

func _input(event: InputEvent) -> void:
	pass
