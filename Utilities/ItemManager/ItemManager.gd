extends Node
##======奖励全局管理=========
signal onItemAdd(item) #获得一个奖励
signal onItemRemove(item) #移除一个奖励

# 装备列表
var item_list = {
	"0" = preload("res://Entities/装备/一级装备/瞄准镜/瞄准镜.tscn"),
	"1" = preload("res://Entities/装备/一级装备/鞋子/鞋子.tscn"),
	"2" = preload("res://Entities/装备/一级装备/瞄准镜/瞄准镜.tscn"),
	"3" = preload("res://Entities/装备/一级装备/瞄准镜/瞄准镜.tscn")
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
