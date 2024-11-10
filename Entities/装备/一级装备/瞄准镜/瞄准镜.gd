extends Item

func now_use():
	PlayerDataManager.伤害加成 += 3

func miss():
	PlayerDataManager.伤害加成 -= 3
