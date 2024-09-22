extends 基础装备

var 血量 = 5
	
func onStart():
	PlayerDataManager.player_hp += 血量

func onDestroy():
	PlayerDataManager.player_hp -= 血量
