extends Node

signal onHpChange(hp,max_hp)
signal onDie()

# 装备列表
var Boss_list = {
	"2" = {
		"orc" = preload("res://scenes/entities/orc/orc.tscn"),
	},
	"1" = {
		"Archer" = preload("res://scenes/entities/archer/archer.tscn"),
	}
}

func getBoss():
	# 获取当前关卡的Boss字典
	var current_boss_dict = Boss_list[str(Utils.now_level)]
	# 获取所有Boss的键名列表
	var boss_keys = current_boss_dict.keys()
	# 随机选择一个键名
	var random_key = boss_keys[randi() % boss_keys.size()]
	# 返回随机选中的Boss场景
	return current_boss_dict[random_key]
