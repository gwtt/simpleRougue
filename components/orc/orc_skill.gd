extends Node
class_name OrcSkill

@export var orc: Orc
@onready var body: Node2D = %body
@export var ghost_node: PackedScene

## 初始速度
var init_speed:float
## 初始攻击速度
var init_attack_speed:float
## 初始攻击前摇
var init_attack_delay:float

func _ready() -> void:
	await owner.ready
	init_speed = orc.orc_stats.get_float("speed")
	init_attack_speed = orc.orc_stats.get_float("attack_speed")
	init_attack_delay = orc.orc_stats.get_float("attack_delay")
	
## 不断狂暴
func rage():
	orc.orc_stats.set_bool("is_rage", true)
	_update_rage_stats()
	orc.orc_stats.set_float("damage_reduction", 0.5)
	# 添加狂暴特效
	body.modulate = Color(1.5, 0.5, 0.5)

	for i in 10:
		await get_tree().create_timer(0.3).timeout
		create_ghost()
	# 3秒后解除狂暴
	_exit_rage_state()

func _exit_rage_state() -> void:
	orc.orc_stats.set_bool("is_rage", false)
	orc.orc_stats.set_float("speed", init_speed)
	orc.orc_stats.set_float("attack_speed", init_attack_speed)
	orc.orc_stats.set_float("attack_delay", init_attack_delay)
	orc.orc_stats.set_float("damage_reduction", 0.0)
	body.modulate = Color(1, 1, 1)

func create_ghost() -> void:
	var ghost = ghost_node.instantiate()
	ghost.set_property(owner.global_position, body , owner.scale)
	add_child(ghost)

func _update_rage_stats() -> void:
	orc.orc_stats.set_float("speed", orc.orc_stats.get_float("speed") * 1.5)
	orc.orc_stats.set_float("attack_speed", orc.orc_stats.get_float("attack_speed") + 10)
	orc.orc_stats.set_float("attack_delay", orc.orc_stats.get_float("attack_delay") * 0.5)
