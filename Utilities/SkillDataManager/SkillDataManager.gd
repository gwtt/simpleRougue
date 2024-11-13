extends Node

#冲锋信号触发
signal onDash()

var skillList:Array[BaseSkill]

const dash = preload("res://Entities/Skill/DashSkill/DashSkill.tscn")

func _ready() -> void:
	skillList.append(dash.instantiate())

func _input(event: InputEvent) -> void:
	pass
