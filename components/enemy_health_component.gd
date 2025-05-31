extends Node2D
class_name EnemyHealthComponent
signal die
signal boss_hp_change
signal onFirstHalfHp()
@export var archer: Archer

var first_half_hp = false
var health:float:
	set(value):
		health = value
		EventBus.push_event("boss_hp_change", [health, archer.archer_stats.get_float("max_health")])
func _ready() -> void:
	await owner.ready
	health = archer.archer_stats.get_float("max_health")

func damage(attack:float) -> void:
	var final_damage = (attack - archer.archer_stats.get_float("defense")) # 计算最终伤害
	Utils.showHitLabel(final_damage,get_parent())
	health -= final_damage
	boss_hp_change.emit()
	
	if health < 0:
		print("死亡")
		die.emit()
		
	if health < archer.archer_stats.get_float("max_health") / 2 and not first_half_hp:
		onFirstHalfHp.emit()
		first_half_hp = true
