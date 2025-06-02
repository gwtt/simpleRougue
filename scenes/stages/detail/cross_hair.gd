extends TextureRect

var rotation_speed = PI

func _ready() -> void:
	set_visibility_layer(101)
	set_process(false)
	Utils.onGameStart.connect(self.GameStart)
	GameStart()
	
func GameStart():
	set_process(true)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	global_position = get_global_mouse_position()
	#global_position = get_global_mouse_position() - size  / 8
	
