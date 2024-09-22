extends Panel


@onready var 装备价格 = $Label2
@onready var 装备名称 = $Label
@onready var 装备信息 = $Label3

var am :基础装备= null
func setData(am:基础装备):
	self.am = am
	装备名称.text = am.装备名称
	装备价格.text = str(am.装备价格)
	装备信息.text = am.装备信息
