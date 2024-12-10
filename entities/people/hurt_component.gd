extends Area2D
class_name  HurtBoxComponent

signal hurt(hitbox, damage)
@export var healthComponent:HealthComponent

func _ready() -> void:
	hurt.connect(onHurt)
	
func onHurt(_hitbox , damage: int) -> void:
	healthComponent.health -= damage
	get_parent().stateSendEvent("to_hurt")
