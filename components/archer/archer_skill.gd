extends Node
class_name ArcherSkill

@export var archer: Archer
@onready var body: Node2D = %body
@onready var state_chart: StateChart = %StateChart
@export var ghost_node: PackedScene
@export var charged_arrow_scene: PackedScene # 蓄力箭矢场景
@onready var archer_animations: ArcherAnimations = %ArcherAnimations
var target_player:Player:
	get:
		return Utils.player
		
func rage():
	## 设置为隐身状态
	archer.archer_stats.set_bool("is_stealthed", true)
	owner.modulate.a = 0.5 # 半透明效果
	# 计算玩家背后的位置
	if target_player:
		var player_direction = owner.global_position.direction_to(target_player.global_position)
		var behind_position = target_player.global_position + player_direction * archer.archer_stats.get_float("safe_distance") * 1.5
		
		# 快速移动到玩家背后
		owner.global_position = behind_position
		# 确保面向玩家
		owner.find_player_and_flip_h()	
		
	archer.archer_stats.set_bool("can_attack", false)
	archer_animations.anim_play("attack2")
	# 蓄力射击
	await archer_animations.animation_finished
	_shoot_charged_arrow()
	archer.archer_stats.set_bool("is_stealthed", false)
	owner.modulate.a = 1.0
	state_chart.send_event("to_walk")
	await get_tree().create_timer(archer.archer_stats.get_float("attack_cooldown")).timeout
	archer.archer_stats.set_bool("can_attack", true)

# 发射蓄力箭矢
func _shoot_charged_arrow() -> void:
	if charged_arrow_scene and target_player:
		var arrow = charged_arrow_scene.instantiate()
		owner.add_child(arrow)
		arrow.global_position = owner.global_position
		arrow.init_target(target_player.global_position)
		arrow.damage = archer.archer_stats.get_float("damage")
