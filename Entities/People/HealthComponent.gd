extends Node2D
class_name HealthComponent
signal onDie()
@export var MAX_HEALTH:float = 10.0
var health:float:
	set(value):
		PlayerDataManager.emit_signal("onHpChange",value,MAX_HEALTH)
		health = value

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack:float) -> void:
	health -= attack
	if health <= 0:
		onDie.emit()
