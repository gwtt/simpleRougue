class_name ArcherStats
extends Resource
## 攻击范围
@export_range(0, 100000) var attack_range: float = 700.0 : set = _set_attack_range
## 安全距离
@export_range(0, 100000) var safe_distance: float = 200.0 : set = _set_safe_distance
## 隐身移动范围
@export_range(0, 100000) var stealth_move_range: float = 150.0 : set = _set_stealth_move_range
## 普通攻击冷却时间
@export_range(0, 100000) var attack_cooldown: float = 0.5 : set = _set_attack_cooldown

## 状态变量
var can_attack: bool = true : set = _set_can_attack
var is_stealthed: bool = false : set = _set_is_stealthed
var target_player_postion: Vector2 = Vector2.ZERO : set = _set_target_player_postion
var anim_speed: float = 1.0 : set = _set_anim_speed
var is_half_health: bool = false : set = _set_is_half_health
var time = 0.0 : set = _set_time
var rage_time = 5.0 : set = _set_rage_time
var damage = 1.5 : set = _set_damage
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

## 新增设置方法
func _set_attack_range(value: float) -> void:
	attack_range = value
	emit_changed()

func _set_safe_distance(value: float) -> void:
	safe_distance = value
	emit_changed()

func _set_stealth_move_range(value: float) -> void:
	stealth_move_range = value
	emit_changed()

func _set_attack_cooldown(value: float) -> void:
	attack_cooldown = value
	emit_changed()

func _set_can_attack(value: bool) -> void:
	can_attack = value
	emit_changed()

func _set_is_stealthed(value: bool) -> void:
	is_stealthed = value
	emit_changed()

func _set_target_player_postion(value: Vector2) -> void:
	target_player_postion = value
	emit_changed()

func _set_anim_speed(value: float) -> void:
	anim_speed = value
	emit_changed()

func _set_is_half_health(value: bool) -> void:
	is_half_health = value
	emit_changed()

func _set_time(value: float) -> void:
	time = value
	emit_changed()

func _set_rage_time(value: float) -> void:
	rage_time = value
	emit_changed()

func _set_damage(value: float) -> void:
	damage = value
	emit_changed()
