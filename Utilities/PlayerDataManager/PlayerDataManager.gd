extends Node
signal buy(item)
signal onWeaponBulletsChange()
signal onWeaponChangeAnim()
signal onWeaponChanged()
signal onHpChange()
signal playerWeaponListChange() #武器列表改变
signal onPlayerDiedChange() #玩家死亡信号
signal onPlayerFireRateChange(player_fire_rate) #玩家复活信号
signal onRewardChange(reward)#奖励变化
signal onSpeedChange(speed)#速度变化
signal onGoldChange(gold)#金钱变化
signal onPlayerLevelChange(level) #玩家等级信号
signal onPlayerExpChange(exp,max_exp) #玩家经验信号
signal onPlayerGoldChange(exp,max_exp) #玩家经验信号
signal onAmmoChange(ammo) #备用子弹数量变化
var player_ammo = 9999999:#子弹数量
	set(value):
		player_ammo = value
		emit_signal("onAmmoChange",player_ammo)
var 移速加成:float = 0.0
var 伤害加成 = 0.0
var 攻速加成 = 0.0
var 子弹暴击率 = 0 #子弹暴击增幅
var 基础伤害 = 0.3 #玩家基础伤害
var player_weapon_list = {} #武器列表
var player_item_list = [] #装备列表

var base_reload_speed = 0 #换弹增幅
var is_change_weapon = false
var gold:int = 100:
	set(value):
		gold = value
		emit_signal("onGoldChange",value)

var player_level = 1:
	set(value):
		player_level = value
		伤害加成 += 0.3
		emit_signal("onPlayerLevelChange",player_level)
var player_exp = 0:
	set(value):
		var max = getMaxExp()
		if player_exp >= max:
			player_exp = 0
			player_level += 1
		else:
			player_exp = value
		emit_signal("onPlayerExpChange",player_exp,max)
var now_Wellen = 1

func _ready() -> void:
	buy.connect(add_item)

func getMaxExp():
	return 1;
	
func add_item(item:Item):
	if !player_item_list.has(item.item_name):
		player_item_list.append(item)
func remove_item(item:Item):
	if !player_item_list.has(item.item_name):
		player_item_list.erase(item)

#添加一把武器
func add_weapon(weapon:BaseGun):
	if !player_weapon_list.has(weapon.weapon_id):
		player_weapon_list[weapon.weapon_id] = weapon
		emit_signal("playerWeaponListChange")
		return true
	return false
