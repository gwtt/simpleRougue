extends Node
signal onWeaponBulletsChange()
signal onWeaponChangeAnim()
signal onWeaponChanged()
signal playerWeaponListChange() #武器列表改变
signal onPlayerFireRateChange(player_fire_rate) #玩家复活信号
signal onRewardChange(reward)#奖励变化
signal onSpeedChange(speed)#血量变化
signal onHpChange(hp,max_hp)#血量变化
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
var 装备列表 = {}
var base_reload_speed = 0 #换弹增幅
var is_change_weapon = false
var gold:int = 100:
	set(value):
		gold = value
		emit_signal("onGoldChange",value)
var player_hp_max = 5: #最大血量
	set(value):
		player_hp_max = value
		emit_signal("onHpChange",player_hp,player_hp_max)
var player_hp = 5: #当前血量
	set(value):
		player_hp = value
		emit_signal("onHpChange",player_hp,player_hp_max)
		if player_hp <= 0:
			emit_signal("onPlayerDeath")
var player_level = 1:
	set(value):
		player_level = value
		伤害加成 += 0.3
		player_hp_max += 0.5
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
#func changeWeapon(weapon_id:int):
	#if is_change_weapon:
		#return
	#if player_weapon_list.has(weapon_id):
		#is_change_weapon = true
		#Utils.player.changeWeapon(weapon_id)
		##Engine.time_scale = 0.1

#添加一把武器
func add_weapon(weapon:BaseGun):
	if !player_weapon_list.has(weapon.weapon_id):
		player_weapon_list[weapon.weapon_id] = weapon
		emit_signal("playerWeaponListChange")
		return true
	return false
func getMaxExp():
	return 1;
	
func 添加装备(am:基础装备):
	if !装备列表.has(am.id):
		装备列表[am.id] = am
		am.onStart()
		add_child(am)
func 去除装备(am:基础装备):
	装备列表.erase(装备列表.find_key(am))
