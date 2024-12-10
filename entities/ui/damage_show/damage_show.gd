extends Label

func _ready() -> void:
	position = -self.size / 2
	pivot_offset = self.size /2
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"scale",Vector2(0.5,0.5),0.2).from(Vector2.ZERO)
	tween.tween_property(self,"position:y",position.y - 20,0.3)
	tween.tween_property(self,"scale",Vector2.ZERO,0.2).set_delay(0.7)
	tween.tween_callback(self.queue_free).set_delay(1)

func setNumber(number):
	text = "-"+str(number)

func setColor(color):
	set("theme_override_colors/font_color",color)

func setString(text_value):
	text = text_value
