extends Area2D
class_name  HurtBoxComponent
signal on_die()
signal on_hp_change()
signal on_hurt(hitbox, damage)
@export var MAX_HEALTH:float = 4.0


func onHurt(_hitbox , damage: int) -> void:
	get_parent().stateSendEvent("to_hurt")
 
func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("enemy"):
		emit_signal("hurt", area, area.damage)
