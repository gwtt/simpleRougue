extends Control
@onready var health_bar: ProgressBar = $"HPUI/血条"
@onready var magic_bar: ProgressBar = $"HPUI/蓝条"
@onready var boss_health_bar: ProgressBar = %Boss血条
@onready var timer: Timer = %Timer
@onready var toast: Label = %toast
@export var player_stats: PlayerStats
func _ready() -> void:
	## 绑定资源变化
	player_stats.changed.connect(on_player_change)
	BossDataManager.onHpChange.connect(on_boss_hp_change)
	on_player_change()
	toast.visible = false
	
func showToast(msg,time):
	timer.stop()
	timer.start(time)
	toast.visible = true
	create_tween().tween_property(toast,"modulate:a",1,0.1).from(0)
	toast.text = tr(msg)

func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(toast,"modulate:a",0,0.2)
	tween.tween_callback(self.toast_hide)

func toast_hide():
	toast.visible = false

func on_player_change():
	health_bar.max_value = player_stats.max_hp
	health_bar.value = player_stats.current_hp
	magic_bar.max_value = player_stats.max_xp
	magic_bar.value = player_stats.current_xp

func on_boss_hp_change(hp,max_hp):
	boss_health_bar.max_value = max_hp
	boss_health_bar.value = hp
