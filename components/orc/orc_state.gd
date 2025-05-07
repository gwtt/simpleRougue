extends Node
class_name OrcState
## 用来控制敌人状态和移动
@export var orc: Orc
@onready var sprite: AnimatedSprite2D = %sprite
@onready var state_chart: StateChart = %StateChart
@onready var walk: AtomicState = %walk
@onready var die: AtomicState = %die
@onready var attack: AtomicState = %attack
@onready var run_away: AtomicState = %runAway
@onready var hit: AtomicState = %hit
@onready var rage: AtomicState = %Rage
@onready var orc_animations: OrcAnimations = %OrcAnimations
@onready var enemy_hit_box_component: EnemyHitBoxComponent = %EnemyHitBoxComponent
@onready var orc_skill: OrcSkill = %OrcSkill

func _ready() -> void:
	# 连接所有状态信号
	walk.state_physics_processing.connect(on_walk_physics_processing)
	die.state_entered.connect(on_die_entered)
	attack.state_physics_processing.connect(on_attack_physics_processing)
	run_away.state_physics_processing.connect(on_run_away_physics_processing)
	hit.state_entered.connect(on_hurt_entered)
	rage.state_entered.connect(on_rage_entered)
	
func stateSendEvent(_name: String):
	state_chart.send_event(_name)
	
#region 状态处理逻辑
## 行走状态物理处理
func on_walk_physics_processing(_delta):
	orc_animations.anim_play("walk")
	orc.velocity = orc._get_safe_velocity()
	orc.move_and_slide()

## 死亡状态进入
func on_die_entered():
	print("%s死亡" % [self.name])
	PlayerDataManager.player_exp += 1
	BossDataManager.onDie.emit()
	stateSendEvent("to_die")
	set_physics_process(false)
	for item in get_node("EffectRoot").get_children():
		item.queue_free()
	get_node("CollisionShape2D").call_deferred("set_disabled",true)
	sprite.play("die")
	await sprite.animation_finished
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),2)
	await tween.finished
	#Utils.open_store()
	queue_free()

## 逃跑状态物理处理 
func on_run_away_physics_processing(_delta):
	orc.velocity = -orc.direction * (orc.SPEED * 1.5)
	orc.move_and_slide()

## 受伤状态进入
func on_hurt_entered():
	orc_animations.anim_play("hit")
	await get_tree().create_timer(0.3).timeout
	stateSendEvent("to_walk")

## 狂暴状态进入
func on_rage_entered():
	stateSendEvent("to_walk")
	orc_skill.rage()
#endregion


func _on_attack_area_area_entered(_area: Area2D) -> void:
	if sprite.animation.begins_with("attack"):
		await sprite.animation_finished
	stateSendEvent("to_attack")

func _on_attack_area_area_exited(_area: Area2D) -> void:
	await sprite.animation_finished
	stateSendEvent("to_walk")

func on_attack_physics_processing(_delta: float):
		# 如果正在攻击，并且动画在播放就直接返回
	if sprite.animation.begins_with("attack") && sprite.is_playing():
		return
	if orc.orc_stats.attack_timer > orc.orc_stats.attack_delay:
		orc._get_safe_velocity()
		orc.orc_stats.attack_timer = 0
		var damage_multiplier = 1.0
		var attack_item = randi_range(1,2)
		sprite.play("attack%d" % attack_item)
		enemy_hit_box_component.meleeAttack(orc.orc_stats.attack_speed * damage_multiplier)
