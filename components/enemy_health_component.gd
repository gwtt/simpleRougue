extends Node2D
class_name EnemyHealthComponent
signal die
signal boss_hp_change
signal onFirstHalfHp()
@export var archer: Archer
var first_half_hp = false
var stats: PandoraEntity
var health:float:
	set(value):
		health = value
		EventBus.push_event("boss_hp_change", [health, stats.get_float("max_health")])
func _ready() -> void:
	await owner.ready
	stats = owner.get_stats()
	health = stats.get_float("max_health")

func damage(attack:float) -> void:
	var final_damage = (attack - stats.get_float("defense")) # 计算最终伤害
	Utils.showHitLabel(final_damage,get_parent())
	health -= final_damage
	boss_hp_change.emit()
	
	if health < 0:
		print("死亡")
		die.emit()
		
	if health < stats.get_float("max_health") / 2 and not first_half_hp:
		onFirstHalfHp.emit()
		first_half_hp = true
