extends BaseEnemy
	
@onready var rage_timer: Timer = $rageTimer
@onready var sprite: AnimatedSprite2D = $body/AnimatedSprite2D
@onready var body: Node2D = $body
@export var ghost_node:PackedScene
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

func _on_walk_state_entered() -> void:
	await get_tree().create_timer(7).timeout
	stateSendEvent("to_rage")
		
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
		var attack_item = randi_range(1,2)
		anim.play("attack%d" % attack_item)
		hitBoxComponent.meleeAttack(attack_speed)

func _on_rage_state_entered() -> void:
	stateSendEvent("to_walk")
	rage_timer.start()
	SPEED *= 2
	attack_speed = 1.5
	# 1秒后解除狂暴
	await get_tree().create_timer(1).timeout
	SPEED /= 2
	attack_speed = 1
	rage_timer.stop()

func _on_rage_timer_timeout() -> void:
	add_ghost()

func add_ghost()->void:
	var ghost = ghost_node.instantiate()
	ghost.set_property(global_position,body,scale,sprite.flip_h)
	get_parent().add_child(ghost)
