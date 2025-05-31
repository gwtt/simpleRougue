class_name ItemPool
extends Resource

@export var available_items: Array[ItemStats]

var item_pool: Array[ItemStats]

func generate_item_pool() -> void:
	item_pool = []
	for unit: ItemStats in available_items:
		for i in unit.pool_count:
			item_pool.append(unit)

func get_random_unit(_rarity: ItemStats.Rarity) -> ItemStats:
	return item_pool.pick_random()

