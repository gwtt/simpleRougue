extends BaseEnemy
@export var speed_increase_rate: float = 0.2  # 每次速度增加的比率
@export var max_speed_multiplier: float = 4.0  # 最大速度倍数
var current_speed_multiplier: float = 1.0
var current_attack_speed_multiplier: float = 1.0
@onready var rage_timer: Timer = $rageTimer
@onready var to_rage_timer: Timer = $toRageTimer
@onready var sprite: AnimatedSprite2D = $body/AnimatedSprite2D
@onready var body: Node2D = $body
@export var ghost_node:PackedScene
# 添加新的属性
@export var combo_max: int = 3  # 最大连击次数
@export var rage_speed_multiplier: float = 2.5  # 狂暴速度倍数
@export var rage_damage_multiplier: float = 1.8  # 狂暴伤害倍数
var current_combo: int = 0
var is_rage: bool = false
func flip_h(flip:bool):
	sprite.flip_h = flip

func _get_safe_velocity() -> Vector2:
	if target_player != null:
		var next_path_position = target_player.global_position
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * SPEED
		if new_velocity.x < 0:
			flip_h(true)
		elif new_velocity.x > 0:
			flip_h(false)
		return new_velocity
	else:
		return Vector2.ZERO
		
func _on_walk_state_processing(delta: float) -> void:
	anim.play("walk")
	velocity = _get_safe_velocity()
	move_and_slide()
	
func _on_attack_area_area_entered(area: Area2D) -> void:
	if anim.animation.begins_with("attack"):
		await anim.animation_finished
	stateSendEvent("to_attack")

func _on_attack_area_area_exited(area: Area2D) -> void:
	await anim.animation_finished
	stateSendEvent("to_walk")
	
func _on_attack_state_processing(delta: float) -> void:
	# 如果正在攻击，并且动画在播放就直接返回
	if anim.animation.begins_with("attack") && anim.is_playing():
		return
	if attack_timer > attack_delay:
		_get_safe_velocity()
		attack_timer = 0
		var damage_multiplier = 1.0
		var attack_item = randi_range(1,2)
		anim.play("attack%d" % attack_item)
		hitBoxComponent.meleeAttack(attack_speed * damage_multiplier)

func _on_rage_state_entered() -> void:
	stateSendEvent("to_walk")
	rage_timer.start()
	is_rage = true
	current_speed_multiplier = rage_speed_multiplier
	current_attack_speed_multiplier = 1.5
	_update_rage_stats()
	healthComponent.damage_reduction = 0.5
	# 添加狂暴特效
	body.modulate = Color(1.5, 0.5, 0.5)
	# 1秒后解除狂暴
	await get_tree().create_timer(3).timeout
	_exit_rage_state()

func _on_rage_timer_timeout() -> void:
	add_ghost()
	if is_rage:
		# 增加速度和攻击速度
		current_speed_multiplier = min(current_speed_multiplier + speed_increase_rate, max_speed_multiplier)
		current_attack_speed_multiplier = min(current_attack_speed_multiplier + speed_increase_rate, max_speed_multiplier)
		_update_rage_stats()

func add_ghost()->void:
	var ghost = ghost_node.instantiate()
	ghost.set_property(global_position,body,scale,body.modulate)
	get_parent().add_child(ghost)


func _exit_rage_state() -> void:
	is_rage = false
	current_speed_multiplier = 1.0
	current_attack_speed_multiplier = 1.0
	_update_rage_stats()
	healthComponent.damage_reduction = 0.0
	body.modulate = Color(1, 1, 1)
	rage_timer.stop()


func _on_to_rage_timer_timeout() -> void:
	stateSendEvent("to_rage")

func _update_rage_stats() -> void:
	SPEED = base_speed * current_speed_multiplier  # 需要添加 base_speed 变量存储初始速度
	attack_speed = current_attack_speed_multiplier
	attack_delay = base_attack_delay / current_attack_speed_multiplier
