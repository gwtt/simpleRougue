extends 基础装备

var 攻击力 = 10
	
func onStart():
	PlayerDataManager.基础伤害 += 攻击力

func onDestroy():
	PlayerDataManager.基础伤害 -= 攻击力
