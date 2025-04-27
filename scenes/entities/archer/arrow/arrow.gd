extends CharacterBody2D

var damage = 1.5
var direction
var speed = 1000

# 添加一个变量来引用粒子系统
@onready var trail_particles: GPUParticles2D = $TrailParticles

func init_target(target_position: Vector2) -> void:
	direction = global_position.direction_to(target_position)
	look_at(target_position)
	# 启动粒子系统
	trail_particles.emitting = true
	await get_tree().create_timer(2).timeout
	disappear()

func _process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func disappear() -> void:
	# 停止粒子发射
	trail_particles.emitting = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	await tween.finished
	queue_free()


func _on_area_2d_area_entered(hurtbox: Area2D) -> void:
	hurtbox.hurt.emit(self, damage)
	disappear()
