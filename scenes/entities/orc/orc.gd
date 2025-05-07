extends CharacterBody2D
class_name Orc
@export var orc_stats: OrcStats
@onready var sprite: AnimatedSprite2D = %sprite

func _get_safe_velocity() -> Vector2:
	var target_player = Utils.player
	if target_player != null:
		var next_path_position = target_player.global_position
		var current_agent_position: Vector2 = self.global_position
		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * orc_stats.speed
		if new_velocity.x < 0:
			sprite.flip_h = true
		elif new_velocity.x > 0:
			sprite.flip_h = false
		return new_velocity
	else:
		return Vector2.ZERO	

func _process(delta: float) -> void:
	orc_stats.attack_timer += 1
