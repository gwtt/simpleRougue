extends TextureRect
@onready var animated_sprite_2d = $"../GameUI/HPUI/金币/Control/AnimatedSprite2D"

var rotation_speed = PI

func _ready() -> void:
	set_process(false)
	Utils.onGameStart.connect(self.GameStart)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	animated_sprite_2d.play("default")
	GameStart()
	pass
func GameStart():
	set_process(true)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	global_position = get_global_mouse_position() - size  / 2
	
