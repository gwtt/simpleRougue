extends 基础装备

var 攻速 = 10
	
func onStart():
	PlayerDataManager.攻速加成 += 攻速

func onDestroy():
	PlayerDataManager.攻速加成 -= 攻速
