extends Bullet

func _process(delta: float) -> void:
	super._process(delta)
	#   大小和伤害越来越小
	scale -= Vector2(0.001,0.001)
	hurt -= 0.0001
