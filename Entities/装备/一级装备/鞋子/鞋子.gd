extends Item


func now_use():
	PlayerDataManager.add_speed_probability += 0.1

func miss():
	PlayerDataManager.add_speed_probability -= 0.1
