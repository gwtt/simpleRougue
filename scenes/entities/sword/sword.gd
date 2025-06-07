extends Node2D
class_name Sword
@onready var sword: Sprite2D = %sword
@onready var sword_head: Node2D = %sword_head
## 挥剑轨迹
@onready var sword_line: Afterimage = %sword_line
@onready var attack_area: Area2D = %attack_area
@export var attack_time: float = 0.1
@export var attack_cool_down: float = 0.5
@export var damage = 10

var is_attack = false
var time = 0

func _ready() -> void:
	## 初始下剑的方向
	## -45度是纠正向上，-30度对应240度
	sword.rotation_degrees = -75
	attack_area.area_entered.connect(on_area_entered)

func _physics_process(delta: float) -> void:
	time += delta
	if is_attack:
		return
	else:		
		self.look_at(get_global_mouse_position())
	
func _unhandled_input(event: InputEvent) -> void:
	if is_attack:
		return
	if event.is_action_pressed("shoot") && time > attack_cool_down + attack_time:
		time = 0
		_rotate(240)
		
func _rotate(angle: float) -> void:
	is_attack = true
	var tween = create_tween().set_parallel(false)
	tween.tween_property(self, "rotation_degrees", self.rotation_degrees + angle, attack_time)
	tween.tween_property(self, "rotation", self.rotation + self.global_position.angle_to(get_global_mouse_position()), attack_cool_down)
	await tween.step_finished
	is_attack = false

func on_area_entered(enemy: Area2D) -> void:
	if enemy.has_method("enemy_hurt") and is_attack:
		enemy.enemy_hurt(sword, damage)
