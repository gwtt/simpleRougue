extends CharacterBody2D

var damage = 2
var direction
var speed = 1000

func init_target(target_position: Vector2) -> void:
	direction = global_position.direction_to(target_position)
	look_at(target_position)
	await get_tree().create_timer(2).timeout
	disappear()

func _process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func disappear() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	await tween.finished
	queue_free()


func _on_area_2d_area_entered(hurtbox: Area2D) -> void:
	hurtbox.hurt.emit(self, damage)
	disappear()
