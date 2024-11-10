extends CanvasLayer
@onready var health_bar: ProgressBar = $"GameUI/HPUI/血条"
@onready var toast = $Control/Label
@onready var toast_ui = $Control
@onready var timer = $Control/Timer

func _ready() -> void:
	Utils.canvasLayer = self
	PlayerDataManager.onHpChange.connect(on_hp_change)
	
	toast_ui.visible = false
	
func crosshairChange(is_show):
	$TextureRect.visible = is_show

func showToast(msg,time):
	timer.stop()
	timer.start(time)
	toast_ui.visible = true
	create_tween().tween_property(toast_ui,"modulate:a",1,0.1).from(0)
	toast.text = tr(msg)

func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(toast_ui,"modulate:a",0,0.2)
	tween.tween_callback(self.toast_hide)

func toast_hide():
	toast_ui.visible = false

func hit():
	var material_hit = $Sprite2D.material
	$Sprite2D.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(material_hit,"shader_parameter/fade",0,0.2).from(0.01)
	tween.tween_callback(func back(): $Sprite2D.visible = false)

func on_hp_change(hp,max_hp):
	health_bar.value = hp
