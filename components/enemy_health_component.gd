extends Node2D
class_name EnemyHealthComponent
signal onDie()
signal onHpChange()
signal onFirstHalfHp()
@export var MAX_HEALTH:float = 160.0
@export var defense:float = 0
@export var damage_reduction:float = 0.0  # 新增减伤百分比属性，范围0-1
var first_half_hp = false
var health:float:
	set(value):
		health = value
		BossDataManager.onHpChange.emit(health,MAX_HEALTH)
func _ready() -> void:
	health = MAX_HEALTH

func damage(attack:float) -> void:
	var final_damage = (attack - defense) * (1 - damage_reduction)  # 计算最终伤害
	Utils.showHitLabel(final_damage,get_parent())
	health -= final_damage
	onHpChange.emit()
	if health < 0:
		print("死亡")
		onDie.emit()
	if health < MAX_HEALTH / 2 and not first_half_hp:
		onFirstHalfHp.emit()
		first_half_hp = true
