extends Area2D
class_name HitBoxComponent

@export var bullet:Bullet

signal hit(hurtbox)

func _init() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: EnemyHurtBoxComponent) -> void:
	print("[Hit] %s => %s" % [self.owner.name, hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(bullet)
