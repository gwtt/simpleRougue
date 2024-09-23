extends Node2D
class_name EnemyHealthComponent
signal onDie()
signal onHpChange()
@export var MAX_HEALTH:float = 10.0
var health:float

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack:float) -> void:
	health -= attack
	onHpChange.emit()
	if health <= 0:
		onDie.emit()
	
