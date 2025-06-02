extends CharacterBody2D
class_name Archer

signal die

@export var stats: PandoraEntity
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var shadow: AnimatedSprite2D = $body/shadow
@onready var effect: AnimatedSprite2D = $body/effect
@onready var enemy_health_component: EnemyHealthComponent = %EnemyHealthComponent
@onready var archer_state: ArcherState = %ArcherState

var archer_stats: PandoraEntity
var target_player:Player:
	get:
		return Utils.player
		
func flip_h(flip: bool):
	sprite.flip_h = flip
	shadow.flip_h = flip
	effect.flip_h = flip

func _ready():
	archer_stats = stats.instantiate()
	enemy_health_component.onFirstHalfHp.connect(_on_half_health)
	enemy_health_component.die.connect(on_die)
func _on_half_health():
	archer_stats.set_float("anim_speed", 2.0)
	archer_stats.set_float("attack_cooldown", 0.2)
	archer_stats.set_bool("is_half_health", true)
	archer_state.stateSendEvent("to_rage")

func find_player_and_flip_h():
	if target_player != null:
		flip_h(global_position.direction_to(target_player.global_position).x < 0)

func on_die() -> void:
	die.emit()

func get_stats():
	return archer_stats
