extends Item

func now_use():
	PlayerDataManager.add_attack_probability += 0.1

func miss():
	PlayerDataManager.add_attack_probability -= 0.1
