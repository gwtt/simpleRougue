extends Sprite2D

func _ready() -> void:
	ghosting()

func set_property(tx_pos:Vector2,tx_node:Node2D,tx_sacle:Vector2,flip_h:bool = false)->void:
	global_position = tx_pos
	self.add_child(tx_node.duplicate())
	self.scale = tx_sacle

	
func ghosting()->void:
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self,"modulate",Color(1,1,1,0),0.75)
	await tween_fade.finished
	queue_free()
