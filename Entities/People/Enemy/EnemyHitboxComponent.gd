extends Area2D
class_name EnemyHitBoxComponent

signal hit(hurtbox)
@export var Density:int = 10
@export var Length:int = 20
@export var RangeAngle:int = 160
@export var Speed:int = 10
@export var Hit_body_record:Array[HurtBoxComponent] = []
#攻击前摇时间
@export var beforeAttackTime:float = 0.15
@export var damage = 1
func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox:HurtBoxComponent) -> void:
	if !Hit_body_record.has(hurtbox):
		Hit_body_record.append(hurtbox)
	else:
		return
	print("[Hit] %s => %s" % [self.owner.name, hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self,damage)

#近战攻击
func meleeAttack()->void:
	await get_tree().create_timer(beforeAttackTime).timeout
	for i in Density:
		var collsion = CollisionShape2D.new()
		var line = SegmentShape2D.new()
		if Utils.player.global_position.y > global_position.y:
			line.b.y = Length
			line.b = line.get_b().rotated(deg_to_rad(i * (-RangeAngle/Density)))
		else:
			line.b.y = -Length
			line.b = line.get_b().rotated(deg_to_rad(i * (RangeAngle/Density)))
		collsion.set_shape(line)
		collsion.debug_color = Color("#ffff00c8")
		call_deferred("add_child",collsion)
		await get_tree().create_timer(0.1*(1.0/Speed)*(1.0/Density)*(17.0/Density)).timeout

	for child in self.get_children():
		child.set_deferred("disabled",true)
		if child.is_inside_tree():
			self.remove_child(child)
		await get_tree().create_timer(0.01).timeout
	
	Hit_body_record.clear()
