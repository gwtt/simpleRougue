extends Node2D
class_name HealthComponent
signal onDie()
signal onHpChange(hp,max_hp)#血量变化
@export var MAX_HEALTH:float = 4.0
var health:float = 4:
	set(value):
		onHpChange.emit(value,MAX_HEALTH)
		health = value

func _ready() -> void:
	health = MAX_HEALTH
	onHpChange.connect(get_parent().onHpChange)
	
func damage(attack:float) -> void:
	health -= attack
	if health <= 0:
		onDie.emit()
