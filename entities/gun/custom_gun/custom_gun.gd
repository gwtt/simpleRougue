extends BaseGun

func _shoot():
	super._shoot()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - tip.global_position).normalized()
	tip.rotation = direction.angle()
	createBullet()

func createBullet():
	for i in 1:
		var b = bullet_scene.instantiate()
		b.setOnwer(player)
		b.position = tip.global_position
		get_tree().root.add_child(b)
		b.rotation = tip.rotation
		fire(b)
		call_deferred("_shootAnim")
		await get_tree().create_timer(0.05).timeout

func _shootAnim():
	super._shootAnim()
	#var tween = get_tree().create_tween().set_parallel(true)
	#tween.tween_property(self, "position", position, 0.15).from(position + Vector2(-1, -1))
	#tween.tween_property($Sprite2D, "scale", Vector2(1,1), 0.15).from(Vector2(0.5, 1.1))


func _on_shoot_timer_timeout():
	can_shoot = true
