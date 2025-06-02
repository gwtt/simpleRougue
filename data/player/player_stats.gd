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
@export_range(0, 10000) var max_hp: int = 3: set = _set_max_hp
## 当前血量
@export_range(0, 10000) var current_hp: int = 0: set = _set_current_hp
## 最大蓝量
@export_range(0, 10000) var max_xp: int = 1: set = _set_max_xp
## 当前蓝量
@export_range(0, 10000) var current_xp: int = 0: set = _set_current_xp


@export var add_attack_probability = 0.0 : set = _set_add_attack_probability
@export var add_hp_probability = 0.0 : set = _set_add_hp_probability
@export var add_mp_probability = 0.0 : set = _set_add_mp_probability
@export var add_coin_probability = 0.0 : set = _set_add_coin_probability
@export var add_exp_probability = 0.0 : set = _set_add_exp_probability
@export var add_attack_rate_probability = 0.0 : set = _set_add_attack_rate_probability
@export var add_range_probability = 0.0 : set = _set_add_range_probability
@export var add_speed_probability = 0.0 : set = _set_add_speed_probability
@export var add_armor_probability = 0.0 : set = _set_add_armor_probability
# 玩家的装备列表
var player_item_list = []

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

## 获取所有玩家信息
func _print_all() -> String:
	var text = ''
	text += "当前等级:[color=yellow]" + str(level) + "[/color]\n"
	text += "最大血量:[color=yellow]" + str(max_hp) + "[/color]\n"
	text += "最大蓝量:[color=yellow]" + str(max_xp) + "[/color]\n"
	text += "移动速度:[color=yellow]" + str(move_speed) + "[/color]\n"
	text += "基础伤害:[color=yellow]" + str(base_damage) + "[/color]\n"
	text += "攻速加成:[color=yellow]" + str(attack_speed) + "[/color]\n"
	text += "幸运值:[color=yellow]" + str(luck) + "[/color]\n"
	text += "加攻概率:[color=yellow]" + str(add_attack_probability) + "[/color]\n"
	text += "加血概率:[color=yellow]" + str(add_hp_probability) + "[/color]\n"
	text += "加魔概率:[color=yellow]" + str(add_mp_probability) + "[/color]\n"
	text += "加金概率:[color=yellow]" + str(add_coin_probability) + "[/color]\n"
	text += "加经验概率:[color=yellow]" + str(add_exp_probability) + "[/color]\n"
	text += "加攻速概率:[color=yellow]" + str(add_attack_rate_probability) + "[/color]\n"
	text += "加范围概率:[color=yellow]" + str(add_range_probability) + "[/color]\n"
	text += "加速度概率:[color=yellow]" + str(add_speed_probability) + "[/color]\n"
	text += "加护甲概率:[color=yellow]" + str(add_armor_probability) + "[/color]\n"
	return text

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

func _set_add_attack_probability(value: float) -> void:
	add_attack_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_hp_probability(value: float) -> void:
	add_hp_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_mp_probability(value: float) -> void:
	add_mp_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_coin_probability(value: float) -> void:
	add_coin_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_exp_probability(value: float) -> void:
	add_exp_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_attack_rate_probability(value: float) -> void:
	add_attack_rate_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_range_probability(value: float) -> void:
	add_range_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_speed_probability(value: float) -> void:
	add_speed_probability = snapped(value, 0.01)
	emit_changed()

func _set_add_armor_probability(value: float) -> void:
	add_armor_probability = snapped(value, 0.01)
	emit_changed()
