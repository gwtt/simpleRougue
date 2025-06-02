class_name ItemPool
extends Resource

@export var available_items: Array[PandoraEntity]

var item_pool: Array[PandoraEntity]

func generate_item_pool() -> void:
	item_pool = []
	for unit: PandoraEntity in available_items:
		for i in unit.get_integer("pool_count"):
			item_pool.append(unit.instantiate())

## 随机挑选一个返回
func get_random_unit(_rarity: ItemStats.Rarity) -> PandoraEntity:
	if item_pool.size() == 0:
		return null
	return item_pool.pick_random()

