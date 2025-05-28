extends Node
class_name ArcherSkill

@export var archer: Archer
@onready var body: Node2D = %body
@export var ghost_node: PackedScene

## 不断狂暴
func rage():
	var timer = get_tree().create_timer(0.1)
	timer.timeout.connect(_on_rage_timer_timeout)
	archer.archer_stats.is_rage = true
	archer.archer_stats.current_speed_multiplier = archer.archer_stats.rage_speed_multiplier
	archer.archer_stats.current_attack_speed_multiplier = 1.5
	_update_rage_stats()
	archer.archer_stats.damage_reduction = 0.5
	# 添加狂暴特效
	body.modulate = Color(1.5, 0.5, 0.5)
	# 1秒后解除狂暴
	await get_tree().create_timer(3).timeout
	_exit_rage_state()

func _exit_rage_state() -> void:
	archer.archer_stats.is_rage = false
	archer.archer_stats.current_speed_multiplier = 1.0
	archer.archer_stats.current_attack_speed_multiplier = 1.0
	_update_rage_stats()
	archer.archer_stats.damage_reduction = 0.0
	body.modulate = Color(1, 1, 1)

func _on_rage_timer_timeout() -> void:
	var ghost = ghost_node.instantiate()
	ghost.set_property(archer.global_position,body,archer.scale,body.modulate)
	get_parent().add_child(ghost)
	if archer.archer_stats.is_rage:
		# 增加速度和攻击速度
		archer.archer_stats.current_speed_multiplier = min(archer.archer_stats.current_speed_multiplier + archer.archer_stats.speed_increase_rate, archer.archer_stats.max_speed_multiplier)
		archer.archer_stats.current_attack_speed_multiplier = min(archer.archer_stats.current_attack_speed_multiplier + archer.archer_stats.speed_increase_rate, archer.archer_stats.max_speed_multiplier)
		_update_rage_stats()
		
func _update_rage_stats() -> void:
	archer.archer_stats.speed = archer.archer_stats.base_speed * archer.archer_stats.current_speed_multiplier  # 需要添加 base_speed 变量存储初始速度
	archer.archer_stats.attack_speed = archer.archer_stats.current_attack_speed_multiplier
	archer.archer_stats.attack_delay = archer.archer_stats.base_attack_delay / archer.archer_stats.current_attack_speed_multiplier
