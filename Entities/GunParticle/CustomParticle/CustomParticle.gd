extends GPUParticles2D

func _ready():
	emitting = true
	await get_tree().create_timer(0.3).timeout
	queue_free()
