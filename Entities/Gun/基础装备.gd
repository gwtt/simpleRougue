extends Node2D
class_name 基础装备


@export var 装备ID = 0 #配件ID
@export var 装备名称 = "" #配件名称
@export var 装备图片:Texture #配件图片
@export_multiline var 装备信息 = "" #介绍
@export var 装备价格 = 100 #价格
var id = Time.get_ticks_usec() #配件在背包中的ID

func _ready() -> void:
	name = str(id)
func onStart():
	pass

func onDestroy():
	pass
