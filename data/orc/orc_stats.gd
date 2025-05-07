class_name OrcStats
extends Resource

## 每次速度增加的比率
@export_range(0, 100000) var speed_increase_rate: float = 0.2: set = _set_speed_increase_rate
## 最大速度倍数
@export_range(0, 100000) var max_speed_multiplier: float = 4.0 : set = _set_max_speed_multiplier
## 当前速度乘
@export_range(0, 100000) var current_speed_multiplier: float = 1.0 : set = _set_current_speed_multiplier

## 最大连击次数
@export_range(0, 100000) var combo_max: int = 3: set = _set_combo_max
## 狂暴速度倍数
@export_range(0, 100000) var rage_speed_multiplier: float = 2.5: set = _set_rage_speed_multiplier
## 狂暴伤害倍数
@export_range(0, 100000) var rage_damage_multiplier: float = 1.8: set = _set_rage_damage_multiplier

@export var current_combo: int = 0 : set =  _set_current_combo
@export var is_rage: bool = false : set = _set_is_rage
## 速度
@export var speed = 50.0: set = _set_speed
@export var base_speed = 50.0
## 伤害
@export var hurt = 1: set = _set_hurt
## 攻击时间
@export var attack_timer = 0 : set =_set_attack_timer
## 攻击前摇
@export var attack_delay = 1 * 30 : set = _set_attack_delay
@export var base_attack_delay = 1 * 30
## 攻击速度
@export var attack_speed = 1.0: set = _set_attack_speed
## 狂暴减伤
@export var damage_reduction = 0.5: set = _set_damage_reduction
func _set_speed_increase_rate(value: float) -> void:
	speed_increase_rate = value
	emit_changed()

func _set_max_speed_multiplier(value: float) -> void:
	max_speed_multiplier = value
	emit_changed()

func _set_current_speed_multiplier(value: float) -> void:
	current_speed_multiplier = value
	emit_changed()

func _set_combo_max(value: int) -> void:
	combo_max = value
	emit_changed()

func _set_rage_speed_multiplier(value: float) -> void:
	rage_speed_multiplier = value
	emit_changed()

func _set_rage_damage_multiplier(value: float) -> void:
	rage_damage_multiplier = value
	emit_changed()

func _set_current_combo(value: int) -> void:
	current_combo = value
	emit_changed()

func _set_is_rage(value: bool) -> void:
	is_rage = value
	emit_changed()

func _set_speed(value: float) -> void:
	speed = value
	emit_changed()

func _set_hurt(value: int) -> void:
	hurt = value
	emit_changed()

func _set_attack_timer(value: int) -> void:
	attack_timer = value
	emit_changed()

func _set_attack_delay(value: int) -> void:
	attack_delay = value
	emit_changed()

func _set_attack_speed(value: float) -> void:
	attack_speed = value
	emit_changed()

func _set_damage_reduction(value: float) -> void:
	damage_reduction = value
	emit_changed()
