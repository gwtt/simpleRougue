extends BaseEnemy

func _ready():
	super._ready()
	anim.play("idle")

func _physics_process(delta):
	super._physics_process(delta)
	if velocity != Vector2.ZERO:
		if velocity.x > 0:
			flip_h(false)
		elif velocity.x < 0 && scale.x == 1:
			flip_h(true)
	else:
		anim.play("idle")
