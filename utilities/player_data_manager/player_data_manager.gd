extends Node
signal buy(item)
signal onWeaponBulletsChange()
signal onWeaponChangeAnim()
signal onWeaponChanged()
signal onHpChange()
signal onMagicChange()
signal playerWeaponListChange() # 武器列表改变
signal onPlayerDiedChange() # 玩家死亡信号
signal onPlayerFireRateChange(player_fire_rate) # 玩家复活信号
signal onRewardChange(reward) # 奖励变化
signal onSpeedChange(speed) # 速度变化
signal onGoldChange(gold) # 金钱变化
signal onPlayerLevelChange(level) # 玩家等级信号
signal onPlayerExpChange(exp, max_exp) # 玩家经验信号
signal onPlayerGoldChange(exp, max_exp) # 玩家经验信号
signal onAmmoChange(ammo) # 备用子弹数量变化
signal attack() # 攻击
var player_ammo = 9999999: # 子弹数量
	set(value):
		player_ammo = value
		emit_signal("onAmmoChange", player_ammo)
var 移速加成: float = 0.0
var 伤害加成 = 0.0
var 攻速加成 = 0.0
var 子弹暴击率 = 100 # 子弹暴击增幅
var 基础伤害 = 0.3 # 玩家基础伤害
var add_attack_probability = 0.0 # 增加攻击力概率
var add_hp_probability = 0.0 # 增加血量概率
var add_mp_probability = 0.0 # 增加魔法概率
var add_coin_probability = 0.0 # 增加金币概率
var add_exp_probability = 0.0 # 增加经验概率
var add_attack_rate_probability = 0.0 # 增加攻速概率
var add_range_probability = 0.0 # 增加范围概率
var add_speed_probability = 0.0 # 增加速度概率
var add_armor_probability = 0.0 # 增加护甲概率

var player_weapon_list = {} # 武器列表
var player_item_list = [] # 装备列表

var base_reload_speed = 0 # 换弹增幅
var is_change_weapon = false
var gold: int = 100:
	set(value):
		gold = value
		emit_signal("onGoldChange", value)

var player_level = 1:
	set(value):
		player_level = value
		伤害加成 += 0.3
		emit_signal("onPlayerLevelChange", player_level)

var player_exp = 0:
	set(value):
		var max_exp = getMaxExp()
		if player_exp >= max_exp:
			player_exp = 0
			player_level += 1
		else:
			player_exp = value
		emit_signal("onPlayerExpChange", player_exp, max_exp)

var player = preload("res://Entities/People/Player/player.tscn")
func _ready() -> void:
	buy.connect(add_item)
	attack.connect(onAttack)
	BossDataManager.onDie.connect(onBossDie)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("无敌"):
		伤害加成 += 9999

func getMaxExp():
	return 1;
	
func add_item(item: Item):
	if !player_item_list.has(item.item_name):
		player_item_list.append(item)
func remove_item(item: Item):
	if !player_item_list.has(item.item_name):
		player_item_list.erase(item)

#添加一把武器
func add_weapon(weapon: BaseGun):
	if !player_weapon_list.has(weapon.weapon_id):
		player_weapon_list[weapon.weapon_id] = weapon
		emit_signal("playerWeaponListChange")
		return true
	return false

func onAttack() -> void:
	if randf() <= add_attack_probability:
		print("伤害加成")
		伤害加成 += 0.1 # 增加10%伤害
		Utils.showStringLabel("攻击+0.1",Utils.player)
		
	if randf() <= add_hp_probability:
		emit_signal("onHpChange") # 触发血量变化信号
		Utils.showStringLabel("血量+0.1",Utils.player)
		
	if randf() <= add_mp_probability:
		emit_signal("onMagicChange") # 触发魔法值变化信号
		
	if randf() <= add_coin_probability:
		gold += 1 # 增加金币
		Utils.showStringLabel("金币+1",Utils.player)
		
	if randf() <= add_exp_probability:
		player_exp += 1 # 增加经验
		Utils.showStringLabel("经验+1",Utils.player)

	if randf() <= add_attack_rate_probability:
		攻速加成 += 0.1 # 增加5%攻速
		emit_signal("onPlayerFireRateChange", 攻速加成)
		Utils.showStringLabel("攻速+0.1",Utils.player)

	if randf() <= add_speed_probability:
		移速加成 += 1 # 增加移速
		emit_signal("onSpeedChange", 移速加成)
		Utils.showStringLabel("移速+1",Utils.player)

func onBossDie():
	gold += 100 * Utils.now_level
	Utils.now_level += 1
