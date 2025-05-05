class_name  PlayerHurtBoxComponent
extends Area2D

## 用来控制玩家受伤的功能

@export var player: Player
@export var player_state: PlayerState

signal on_die()
signal on_hp_change()
signal on_hurt()

func hurt(_hitbox, damage: int) -> void:
	player_state.stateSendEvent("to_hurt")
	var nodes = get_tree().get_nodes_in_group("reward")
	var temp_hurt = 0
	for node in nodes:
		if node.connect_beforePlayerHit:
			var num = node.call("beforePlayerHit", damage)
			temp_hurt += num
	damage += temp_hurt
	if damage < 1:
		damage = 1
	player.player_stats.current_hp -= damage
	on_hurt.emit()
	Utils.showHitLabel(damage, self)
	get_tree().call_group("control", "hit")
	#Utils.freeze_frame = true
	Utils.freezeFrame(0.1)
	for node in nodes:
		if node.connect_afterPlayerHit:
			node.call("afterPlayerHit", damage)
	if player.player_stats.current_hp < 0:
		player_state.stateSendEvent("to_die")
		
func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("enemy"):
		on_hurt.emit(area, area.damage)
