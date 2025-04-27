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
