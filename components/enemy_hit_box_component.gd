extends Area2D
class_name EnemyHitBoxComponent

signal hit(hurtbox)
@export var Density:int = 10
@export var Length:int = 20
@export var RangeAngle:int = 200
@export var Speed:int = 10
@export var Hit_body_record:Array[PlayerHurtBoxComponent] = []
#攻击前摇时间
@export var beforeAttackTime:float = 0.15
@export var damage = 20
func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox:PlayerHurtBoxComponent) -> void:
	if !Hit_body_record.has(hurtbox):
		Hit_body_record.append(hurtbox)
	else:
		return
	print("[Hit] %s => %s" % [self.owner.name, hurtbox.owner.name])
	#hit.emit(hurtbox)
	# 使对方受伤
	hurtbox.hurt(self, damage)

#近战攻击
func meleeAttack(attack_speed: int)->void:
	await get_tree().create_timer(beforeAttackTime).timeout
	for i in Density:
		var collsion = CollisionShape2D.new()
		var line = SegmentShape2D.new()
		if Utils.player.global_position.x < global_position.x:
			line.b.y = Length
			line.b = line.get_b().rotated(deg_to_rad(i * (RangeAngle/Density)))
		else:
			line.b.y = Length
			line.b = line.get_b().rotated(deg_to_rad(i * (-RangeAngle/Density)))
		collsion.set_shape(line)
		collsion.debug_color = Color("#ffff00c8")
		call_deferred("add_child",collsion)
		await get_tree().create_timer(0.2*(1.0/Speed)*(1.0/Density)*(17.0/Density)/attack_speed).timeout
	await get_tree().create_timer(0.1).timeout
	for child in self.get_children():
		child.set_deferred("disabled",true)
		if child.is_inside_tree():
			self.remove_child(child)
		await get_tree().create_timer(0.01).timeout
	
	Hit_body_record.clear()
