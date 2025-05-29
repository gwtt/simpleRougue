extends BaseEnemy
class_name Archer
@export var archer_stats: ArcherStats
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var shadow: AnimatedSprite2D = $body/shadow
@onready var effect: AnimatedSprite2D = $body/effect

# 状态变量
var can_attack: bool = true
var is_stealthed: bool = false
var target_player_postion: Vector2 = Vector2.ZERO
var anim_speed: float = 1.0
var is_half_health: bool = false
var time = 0.0
var rage_time = 5.0
var damage = 1.5
func flip_h(flip: bool):
	sprite.flip_h = flip
	shadow.flip_h = flip
	effect.flip_h = flip

func _ready():
	super._ready()
	healthComponent.onFirstHalfHp.connect(_on_half_health)

func _process(delta: float) -> void:
	if is_half_health:
		time += delta
		if time >= rage_time:
			stateSendEvent("to_rage")
			time = 0.0

func _on_half_health():
	anim_speed = 2.0
	archer_stats.attack_cooldown = 0.2
	stateSendEvent("to_rage")
	is_half_health = true

func find_player_and_flip_h():
	if target_player != null:
		flip_h(global_position.direction_to(target_player.global_position).x < 0)

