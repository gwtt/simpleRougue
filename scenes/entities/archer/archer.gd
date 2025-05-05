extends BaseEnemy
@onready var sprite: AnimatedSprite2D = $body/AnimatedSprite2D
@onready var shadow: AnimatedSprite2D = $body/shadow
@onready var effect: AnimatedSprite2D = $body/effect
@export var arrow_scene: PackedScene # 普通箭矢场景
@export var charged_arrow_scene: PackedScene # 蓄力箭矢场景
@export var attack_range: float = 700.0 # 攻击范围
@export var safe_distance: float = 200.0 # 安全距离
@export var stealth_move_range: float = 150.0 # 隐身移动范围
@export var attack_cooldown: float = 0.5 # 普通攻击冷却时间

# 状态变量
var can_attack: bool = true
var is_stealthed: bool = false
var target_player_postion: Vector2 = Vector2.ZERO
var anim_speed: float = 1.0
var is_half_health: bool = false
var time = 0.0
var rage_time = 5.0
var damage = 1.5
func flip_h(flip: bool):
	sprite.flip_h = flip
	shadow.flip_h = flip
	effect.flip_h = flip

func _ready():
	super._ready()
	healthComponent.onFirstHalfHp.connect(_on_half_health)

func _process(delta: float) -> void:
	if is_half_health:
		time += delta
		if time >= rage_time:
			stateSendEvent("to_rage")
			time = 0.0

func _on_half_health():
	anim_speed = 2.0
	attack_cooldown = 0.2
	stateSendEvent("to_rage")
	is_half_health = true

func find_player_and_flip_h():
	if target_player != null:
		flip_h(global_position.direction_to(target_player.global_position).x < 0)


func _get_safe_velocity() -> Vector2:
	var desired_velocity := Vector2.ZERO
	if target_player != null:
		var distance = global_position.distance_to(target_player.global_position)
		var direction = global_position.direction_to(target_player.global_position)
		# 如果距离大于攻击范围，向玩家移动
		if distance > attack_range:
			desired_velocity = direction * SPEED
		# 如果距离小于最小安全距离，远离玩家
		elif distance < safe_distance: # 使用攻击范围的70%作为最小安全距离
			desired_velocity = -direction * SPEED * 2
		# 在理想范围内，尝试保持位置或进行小幅度移动
		else:
			# 可以添加小幅度的横向移动，使弓箭手的移动更自然
			var perpendicular = Vector2(-direction.y, direction.x)
			desired_velocity = perpendicular * SPEED * 0.5 * sin(Time.get_ticks_msec() / 1000.0)
		if direction.x < 0:
			flip_h(true)
		elif direction.x > 0:
			flip_h(false)
	return desired_velocity.limit_length(SPEED)


# 状态：行走
func _on_walk_state_entered() -> void:
	anim.play("walk")

func _on_walk_state_processing(_delta: float) -> void:
	if target_player != null: # 添加hit检查
		var distance = global_position.distance_to(target_player.global_position)
		if distance <= safe_distance:
			velocity = _get_safe_velocity()
			move_and_slide()
		elif distance <= attack_range and can_attack:
			stateSendEvent("to_attack")
		else:
			velocity = _get_safe_velocity()
			move_and_slide()

# 状态：攻击
func _on_attack_state_entered() -> void:
	find_player_and_flip_h()
	can_attack = false
	anim.play("attack1", anim_speed)
	target_player_postion = target_player.global_position
	await anim.animation_finished
	_shoot_arrow()
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	stateSendEvent("to_walk")

func _on_attack_state_processing(_delta: float) -> void:
	pass

# 状态：隐身技能（狂暴）
func _on_rage_state_entered() -> void:
	await anim.animation_finished
	print("进入狂暴状态")
	is_stealthed = true
	modulate.a = 0.5 # 半透明效果
	# 计算玩家背后的位置
	if target_player:
		var player_direction = global_position.direction_to(target_player.global_position)
		var behind_position = target_player.global_position + player_direction * safe_distance * 1.5
		
		# 快速移动到玩家背后
		global_position = behind_position
		# 确保面向玩家
		find_player_and_flip_h()	
		
	can_attack = false
	anim.play("attack2", anim_speed)
	# 蓄力射击
	await anim.animation_finished
	_shoot_charged_arrow()
	is_stealthed = false
	modulate.a = 1.0
	stateSendEvent("to_walk")
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _on_rage_state_processing(_delta: float) -> void:
	pass

# 发射普通箭矢
func _shoot_arrow() -> void:
	if arrow_scene and target_player:
		var arrow = arrow_scene.instantiate()
		self.add_child(arrow)
		arrow.global_position = global_position
		arrow.init_target(target_player_postion)
		arrow.damage = damage
# 发射蓄力箭矢
func _shoot_charged_arrow() -> void:
	if charged_arrow_scene and target_player:
		var arrow = charged_arrow_scene.instantiate()
		self.add_child(arrow)
		arrow.global_position = global_position
		arrow.init_target(target_player_postion)
		arrow.damage = damage
