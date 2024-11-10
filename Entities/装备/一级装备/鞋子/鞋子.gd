extends Item


func now_use():
	PlayerDataManager.移速加成 += 1

func miss():
	PlayerDataManager.移速加成 -= 1
