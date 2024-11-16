extends Camera2D

@onready var phantom_camera_2d: PhantomCamera2D = $"../PhantomCamera2D"

var is_shake = false
func _ready():
	add_to_group("camera")

#func shootShake(_step):
	#if int(Utils.shake) == 0:
		#return
	#if is_shake:
		#return
	#is_shake = true
	#phantom_camera_2d.visible = false
	#_step *= Utils.shake
	#var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	#tween.tween_property(self,"offset",_step,0.01)
	#tween.tween_property(self,"offset",Vector2.ZERO,0.011)
	#tween.tween_callback(func end():
		#phantom_camera_2d.visible = true
		#is_shake = false)
