extends CharacterBody2D
class_name Orc

signal die

@export var stats: PandoraEntity
@onready var sprite: AnimatedSprite2D = %sprite
@onready var enemy_health_component: EnemyHealthComponent = %EnemyHealthComponent

var orc_stats: PandoraEntity

func _ready() -> void:
	orc_stats = stats.instantiate()
	enemy_health_component.die.connect(on_die)
	
## 获取速度
func _get_safe_velocity() -> Vector2:
	var target_player = Utils.player
	if target_player != null:
		var next_path_position = target_player.global_position
		var current_agent_position: Vector2 = self.global_position
		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * orc_stats.get_float("speed")
		if new_velocity.x < 0:
			sprite.flip_h = true
		elif new_velocity.x > 0:
			sprite.flip_h = false
		return new_velocity
	else:
		return Vector2.ZERO	

func get_stats():
	return orc_stats

func on_die():
	die.emit()
