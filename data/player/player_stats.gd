class_name PlayerStats
extends Resource

## 金币
@export_range(0, 100000) var gold: int : set = _set_gold
## 经验
@export_range(0, 100000) var xp: int : set = _set_xp
## 等级
@export_range(0, 100000) var level: int : set = _set_level
## 移动速度
@export_range(0, 100000) var move_speed: int = 200 : set = _set_move_speed
## 攻速加成
@export_range(0, 100000) var attack_speed: int : set = _set_attack_speed
## 基础伤害
@export_range(0, 10000) var base_damage: float = 0.3 : set = _set_base_damage
## 幸运值
@export_range(0, 100000) var luck: int = 0 : set = _set_luck
## 最大血量
@export_range(0, 10000) var max_hp: int = 0: set = _set_max_hp
## 当前血量
@export_range(0, 10000) var current_hp: int = 0: set = _set_current_hp
## 最大蓝量
@export_range(0, 10000) var max_xp: int = 0: set = _set_max_xp
## 当前蓝量
@export_range(0, 10000) var current_xp: int = 0: set = _set_current_xp


@export var add_attack_probability = 0.0 # 增加攻击力概率
@export var add_hp_probability = 0.0 # 增加血量概率
@export var add_mp_probability = 0.0 # 增加魔法概率
@export var add_coin_probability = 0.0 # 增加金币概率
@export var add_exp_probability = 0.0 # 增加经验概率
@export var add_attack_rate_probability = 0.0 # 增加攻速概率
@export var add_range_probability = 0.0 # 增加范围概率
@export var add_speed_probability = 0.0 # 增加速度概率
@export var add_armor_probability = 0.0 # 增加护甲概率
func get_current_xp_requirement() -> int:
	var next_level = clampi(level+1, 1, 1000)
	return next_level * 100


func _set_gold(value: int) -> void:
	gold = value
	emit_changed()


func _set_xp(value: int) -> void:
	xp = value
	emit_changed()
	
	if level == 10:
		return
	
	var xp_requirement: int = get_current_xp_requirement()
	
	while  xp >= xp_requirement:
		level += 1
		xp -= xp_requirement
		xp_requirement = get_current_xp_requirement()
		emit_changed()


func _set_level(value: int) -> void:
	level = value
	emit_changed()

func _set_move_speed(value: int) -> void:
	move_speed = value
	emit_changed()

func _set_attack_speed(value: int) -> void:
	attack_speed = value
	emit_changed()

func _set_base_damage(value: float) -> void:
	base_damage = value
	emit_changed()

func _set_luck(value: int) -> void:
	luck = value
	emit_changed()

func _set_max_hp(value: int) -> void:
	max_hp = value
	emit_changed()

func _set_current_hp(value: int) -> void:
	current_hp = value
	emit_changed()

func _set_max_xp(value: int) -> void:
	max_xp = value
	emit_changed()
	
func _set_current_xp(value: int) -> void:
	current_xp = value
	emit_changed()


const ROLL_RARITIES := {
	1:  [ItemStats.Rarity.COMMON],
	2:  [ItemStats.Rarity.COMMON],
	3:  [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON],
	4:  [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON, ItemStats.Rarity.RARE],
	5:  [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON, ItemStats.Rarity.RARE],
	6:  [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON, ItemStats.Rarity.RARE],
	7:  [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON, ItemStats.Rarity.RARE, ItemStats.Rarity.LEGENDARY],
	8:  [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON, ItemStats.Rarity.RARE, ItemStats.Rarity.LEGENDARY],
	9:  [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON, ItemStats.Rarity.RARE, ItemStats.Rarity.LEGENDARY],
	10: [ItemStats.Rarity.COMMON, ItemStats.Rarity.UNCOMMON, ItemStats.Rarity.RARE, ItemStats.Rarity.LEGENDARY],
}
const ROLL_CHANCES := {
	1: [1],
	2: [1],
	3: [7.5, 2.5],
	4: [6.5, 3.0, 0.5],
	5: [5.0, 3.5, 1.5],
	6: [4.0, 4.0, 2.0],
	7: [2.75, 4.0, 3.24, 0.1],
	8: [2.5, 3.75, 3.45, 0.3],
	9: [1.75, 2.75, 4.5, 1.0],
	10: [1.0, 2.0, 4.5, 2.5],
}

## 根据等级来获取稀有度
func get_random_rarity_for_level() -> ItemStats.Rarity:
	var rng = RandomNumberGenerator.new()
	var array: Array = ROLL_RARITIES[level]
	var weights: PackedFloat32Array = PackedFloat32Array(ROLL_CHANCES[level])
	return array[rng.rand_weighted(weights)]
