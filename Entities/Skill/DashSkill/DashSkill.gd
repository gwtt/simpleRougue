extends BaseSkill
@onready var texture_rect: TextureRect = $TextureRect
@onready var image: Sprite2D = $image
@onready var cool_down: TextureProgressBar = $coolDown
@onready var key: Label = $Key
@onready var time: Label = $Time
@onready var timer: Timer = $Timer
var change_key = " ":
	set(value):
		change_key = value
		key.text = 	OS.get_keycode_string(change_key)
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = change_key
		shortcut.events = [input_key]
func _ready() -> void:
	change_key = KEY_SHIFT
	change_key = KEY_SPACE
	cool_down.max_value = timer.wait_time * 100
	cool_down.value = 0
	set_process(false)
	
func _process(delta: float) -> void:
	time.text = "%3.1f" % timer.time_left
	cool_down.value = timer.time_left * 100
	
#获取技能触发的效果
func apply()->void:
	SkillDataManager.emit_signal("onDash")

func _on_pressed() -> void:
	self.apply()
	timer.start()
	disabled = true
	set_process(true)


func _on_timer_timeout() -> void:
	disabled = false
	time.text = ""
	cool_down.value = 0
	set_process(false)
