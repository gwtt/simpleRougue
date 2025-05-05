class_name ItemStats
extends Resource

enum Rarity {COMMON, UNCOMMON, RARE, LEGENDARY}

# 装备图标
@export var item: Texture
@export var item_name: String
# 装备类型（装备、技能）
@export var type: String
# 描述
@export var description:String
# 池子里面有多少个
@export var pool_count: int = 1
@export var cost = 100
# 等级
@export_range(0, 100000) var level: int : set = _set_level
# 移动速度加成
@export_range(0, 100000) var move_speed: int : set = _set_move_speed
# 攻速加成加成
@export_range(0, 100000) var attack_speed: int : set = _set_attack_speed
# 基础伤害加成
@export_range(0, 10000) var base_damage: float : set = _set_base_damage
# 幸运值加成
@export_range(0, 100000) var luck: int : set = _set_luck
# 最大血量加成
@export_range(0, 10000) var hp: int : set = _set_hp
# 防御加成
@export_range(0, 10000) var defense: int : set = _set_defense
# 暴击率加成（百分比）
@export_range(0, 100) var critical_chance: float : set = _set_critical_chance
# 暴击伤害加成（百分比）
@export_range(0, 200) var critical_damage: float : set = _set_critical_damage
# 生命偷取（百分比）
@export_range(0, 100) var life_steal: float : set = _set_life_steal
# 生命回复（每秒）
@export_range(0, 1000) var health_regen: int : set = _set_health_regen
# 技能冷却缩减（百分比）
@export_range(0, 100) var cooldown_reduction: float : set = _set_cooldown_reduction
# 经验加成（百分比）
@export_range(0, 500) var exp_bonus: float : set = _set_exp_bonus
# 护甲穿透（百分比）
@export_range(0, 100) var armor_penetration: float : set = _set_armor_penetration
# 射程
@export_range(0, 10000) var range: int: set = _set_range

func get_current_xp_requirement() -> int:
	var next_level = clampi(level+1, 1, 1000)
	return next_level * 100


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

func _set_hp(value: int) -> void:
	hp = value
	emit_changed()

# 新增setter方法
func _set_defense(value: int) -> void:
	defense = value
	emit_changed()

func _set_critical_chance(value: float) -> void:
	critical_chance = value
	emit_changed()

func _set_critical_damage(value: float) -> void:
	critical_damage = value
	emit_changed()

func _set_life_steal(value: float) -> void:
	life_steal = value
	emit_changed()

func _set_health_regen(value: int) -> void:
	health_regen = value
	emit_changed()

func _set_cooldown_reduction(value: float) -> void:
	cooldown_reduction = value
	emit_changed()

func _set_exp_bonus(value: float) -> void:
	exp_bonus = value
	emit_changed()

func _set_armor_penetration(value: float) -> void:
	armor_penetration = value
	emit_changed()

func _set_range(value: int) -> void:
	range = value
	emit_changed()
