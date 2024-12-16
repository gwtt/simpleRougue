extends Area2D
class_name  HurtBoxComponent

signal hurt(hitbox, damage)
@export var healthComponent:HealthComponent
var controller: AbstractController = AbstractController.new()
func _ready() -> void:
	controller.set_architecture(SimpleArchitecture.interface(SimpleArchitecture))
	hurt.connect(onHurt)
	
func onHurt(_hitbox , damage: int) -> void:
	healthComponent.health -= damage
	get_parent().stateSendEvent("to_hurt")
 
