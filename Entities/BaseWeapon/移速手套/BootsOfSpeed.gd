extends 基础装备

var 速度 = 50
	
func onStart():
	PlayerDataManager.移速加成 += 速度

func onDestroy():
	PlayerDataManager.移速加成 -= 速度
