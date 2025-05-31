extends Node
class_name ArcherState
## 用来控制敌人状态和移动
@export var archer: Archer
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var state_chart: StateChart = %StateChart
@onready var walk: AtomicState = %walk
@onready var die: AtomicState = %die
@onready var attack: AtomicState = %attack
@onready var run_away: AtomicState = %runAway
@onready var hit: AtomicState = %hit
@onready var rage: AtomicState = %Rage
@onready var archer_animations: ArcherAnimations = %ArcherAnimations
@onready var archer_skill: ArcherSkill = %ArcherSkill
@export var arrow_scene: PackedScene # 普通箭矢场景

var time: float = 0
var target_player:Player:
	get:
		return Utils.player
		
func _ready() -> void:
	# 连接所有状态信号
	walk.state_physics_processing.connect(on_walk_physics_processing)
	die.state_entered.connect(on_die_entered)
	attack.state_physics_processing.connect(on_attack_physics_processing)
	run_away.state_physics_processing.connect(on_run_away_physics_processing)
	hit.state_entered.connect(on_hurt_entered)
	rage.state_entered.connect(on_rage_entered)
	archer.die.connect(on_die)
	
func stateSendEvent(_name: String):
	state_chart.send_event(_name)
	
#region 状态处理逻辑
## 行走状态物理处理
func on_walk_physics_processing(_delta):
	archer_animations.anim_play("walk", archer.archer_stats.get_float("anim_speed"))
	if target_player != null: # 添加hit检查
		var distance = owner.global_position.distance_to(target_player.global_position)
		if distance <= archer.archer_stats.get_float("safe_distance"):
			owner.velocity = _get_safe_velocity()
			owner.move_and_slide()
		elif distance <= archer.archer_stats.get_float("attack_range") and archer.archer_stats.get_bool("can_attack"):
			stateSendEvent("to_attack")
		else:
			owner.velocity = _get_safe_velocity()
			owner.move_and_slide()
	archer.move_and_slide()

## 死亡状态进入
func on_die_entered():
	print("%s死亡" % [archer.name])
	PlayerDataManager.player_exp += 1
	EventBus.push_event("boss_die")
	set_physics_process(false)
	sprite.play("die")
	await sprite.animation_finished
	var tween = create_tween()
	tween.tween_property(archer, "modulate",Color(1,1,1,0),2)
	await tween.finished
	queue_free()

## 逃跑状态物理处理 
func on_run_away_physics_processing(_delta):
	archer.velocity = -archer.direction * (archer.SPEED * 1.5)
	archer.move_and_slide()

## 受伤状态进入
func on_hurt_entered():
	archer_animations.anim_play("hit")
	await get_tree().create_timer(0.3).timeout
	stateSendEvent("to_walk")

## 状态：隐身技能（狂暴）
func on_rage_entered():
	archer_skill.rage()
	print("进入狂暴状态")

#endregion


func on_attack_physics_processing(_delta: float):
	if archer.archer_stats.get_bool("is_half_health"):
		time += _delta
		if time >= archer.archer_stats.get_float("rage_time"):
			stateSendEvent("to_rage")
			time = 0
			return
	if archer.archer_stats.get_bool("can_attack") == false:
		return
	owner.find_player_and_flip_h()
	archer.archer_stats.set_bool("can_attack", false) 
	archer_animations.anim_play("attack1", archer.archer_stats.get_float("anim_speed"))
	archer.archer_stats.set_vector2("target_player_postion", target_player.global_position)
	await archer_animations.animation_finished
	_shoot_arrow()
	await get_tree().create_timer(archer.archer_stats.get_float("attack_cooldown")).timeout
	archer.archer_stats.set_bool("can_attack", true)
	stateSendEvent("to_walk")


func _get_safe_velocity() -> Vector2:
	var desired_velocity := Vector2.ZERO
	if target_player != null:
		var distance = owner.global_position.distance_to(target_player.global_position)
		var direction = owner.global_position.direction_to(target_player.global_position)
		# 如果距离大于攻击范围，向玩家移动
		if distance > archer.archer_stats.get_float("attack_range"):
			desired_velocity = direction * archer.archer_stats.get_float("speed")
		# 如果距离小于最小安全距离，远离玩家
		elif distance < archer.archer_stats.get_float("safe_distance"): # 使用攻击范围的70%作为最小安全距离
			desired_velocity = -direction * archer.archer_stats.get_float("speed") * 2
		# 在理想范围内，尝试保持位置或进行小幅度移动
		else:
			# 可以添加小幅度的横向移动，使弓箭手的移动更自然
			var perpendicular = Vector2(-direction.y, direction.x)
			desired_velocity = perpendicular * archer.archer_stats.get_float("speed") * 0.5 * sin(Time.get_ticks_msec() / 1000.0)
		if direction.x < 0:
			owner.flip_h(true)
		elif direction.x > 0:
			owner.flip_h(false)
	return desired_velocity.limit_length(archer.archer_stats.get_float("speed"))


# 发射普通箭矢
func _shoot_arrow() -> void:
	if arrow_scene and target_player:
		var arrow = arrow_scene.instantiate()
		owner.add_child(arrow)
		arrow.global_position = owner.global_position
		arrow.init_target(archer.archer_stats.get_vector2("target_player_postion"))
		arrow.damage = archer.archer_stats.get_float("damage")

func on_die() -> void:
	stateSendEvent("to_die")
