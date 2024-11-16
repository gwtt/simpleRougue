extends Node2D
class_name EnemyHealthComponent
signal onDie()
signal onHpChange()
signal onFirstHalfHp()
@export var MAX_HEALTH:float = 160.0
var first_half_hp = false
var health:float:
	set(value):
		health = value
		BossDataManager.onHpChange.emit(health,MAX_HEALTH)
func _ready() -> void:
	health = MAX_HEALTH

func damage(attack:float) -> void:
	health -= attack
	onHpChange.emit()
	if health < 0:
		print("死亡")
		onDie.emit()
	if health < MAX_HEALTH / 2 and not first_half_hp:
		onFirstHalfHp.emit()
		first_half_hp = true

