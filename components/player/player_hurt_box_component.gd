class_name  PlayerHurtBoxComponent
extends Area2D

## 用来控制玩家受伤的功能

@export var player: Player
@export var player_state: PlayerState

signal on_die()
signal on_hp_change()
signal on_hurt()

func hurt(_hitbox, damage: int) -> void:
	print("玩家收到伤害: %s" % [damage])
	player_state.stateSendEvent("to_hurt")
	player.player_stats.current_hp -= damage
	on_hurt.emit()
	Utils.showHitLabel(damage, self)
	get_tree().call_group("control", "hit")
	#Utils.freeze_frame = true
	Utils.freezeFrame(0.1)
	if player.player_stats.current_hp <= 0:
		on_die.emit()
		player_state.stateSendEvent("to_die")
		print("玩家死亡")
		
func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("enemy"):
		on_hurt.emit(area, area.damage)
