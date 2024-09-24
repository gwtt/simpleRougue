extends BaseEnemy
@onready var state_chart: StateChart = $StateChart
var is_atk = false
var is_die = false

var is_flip:bool = false	

func flip_h(flip:bool):
	if is_flip == flip:
		return
	is_flip = flip
	var x_axis = self.scale.x
	var y_axis = self.scale.y
	set_scale(Vector2(-x_axis,y_axis))


func _get_safe_velocity() -> Vector2:
	if target_player != null:
		var next_path_position = target_player.global_position
		#var next_path_position = navigationAgent2D.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * SPEED
		if new_velocity.x < 0:
			flip_h(false)
		elif new_velocity.x > 0:
			flip_h(true)
		return new_velocity
	else:
		return Vector2.ZERO
		
func _on_walk_state_processing(delta: float) -> void:
	anim.play("walk")
	velocity = _get_safe_velocity()
	move_and_slide()
	

func _on_attack_area_area_entered(area: Area2D) -> void:
	state_chart.send_event("to_attack")

func _on_attack_area_area_exited(area: Area2D) -> void:
	await anim.animation_looped
	state_chart.send_event("to_walk")

func _on_attack_state_entered() -> void:
	var attack_item = randi_range(1,2)
	anim.play("attack%d" % attack_item)
	hitBoxComponent.meleeAttack()

func _on_attack_state_processing(delta: float) -> void:
	pass # Replace with function body.
