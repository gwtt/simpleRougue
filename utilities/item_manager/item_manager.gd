extends Node
##======奖励全局管理=========
signal onItemAdd(item) #获得一个奖励
signal onItemRemove(item) #移除一个奖励

# 装备列表
var item_list = {
	"0" = preload("res://entities/equipment/first_equipment/scope/scope.tscn"),
	"1" = preload("res://entities/equipment/first_equipment/shoes/shoes.tscn"),
	"2" = preload("res://entities/equipment/first_equipment/scope/scope.tscn"),
	"3" = preload("res://entities/equipment/first_equipment/scope/scope.tscn")
}

var item_shop_list = []
var item_max = 4

func getShopList(is_reload = false):
	if item_shop_list.is_empty() || is_reload:
		item_shop_list.clear()
		var keys = item_list.keys()
		keys.shuffle()
		for i in item_max:
			item_shop_list.append(keys.pop_back())
	return item_shop_list

func addReward(rw:BaseReward):
	pass

func removeReward(rw:BaseReward):
	pass
