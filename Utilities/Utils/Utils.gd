extends Node

signal onGameStart()
var now_level = 1 #当前关卡
var shake = 1.0 #振动幅度
var canvasLayer:CanvasLayer
var pause_state = false #暂停状态
var is_game_start = false #游戏是否开始
var player:Player
var boss:BaseEnemy
var store_ins
var freeze_frame = false
var player_init_postion = Vector2.ZERO
var boss_init_postion = Vector2.ZERO
enum GUN_CHANGE_TYPE { #切枪类型
	CHANGE, #切换枪械
	RELOAD #切换子弹
}
var store = preload("res://Entities/UI/store/选择界面.tscn")

var weapon_list = {
	"0" = preload("res://Entities/Gun/CustomGun/CustomGun.tscn"),
}
var temp_am_list = []

const hitlabel = preload("res://Entities/UI/DamageShow/伤害显示.tscn")
	
func gameStart():
	is_game_start = true
	emit_signal("onGameStart")
	
func showHitLabel(num,target:Node2D):
	var ins = hitlabel.instantiate()
	ins.setNumber(num)
	target.add_child(ins)

func showStringLabel(text,target:Node2D):
	var ins = hitlabel.instantiate()
	ins.setString(text)
	target.add_child(ins)

#伤害数字 加强版
func showHitLabelMore(num,target:Node2D,position = Vector2.ZERO,color = Color.WHITE):
	var ins = hitlabel.instantiate()
	ins.setNumber(num)
	ins.setColor(color)
	target.add_child(ins)
	ins.global_position = position
	
func freezeFrame(scale):
	if !freeze_frame && scale > 0:
		# 冻结帧
		pass
		#freeze_frame = true
		# 将时间比例设置为0.1
		#Engine.time_scale = scale
	
func showToast(msg,time = 1):
	if canvasLayer:
		canvasLayer.showToast(msg,time)

func crosshairChange(is_change):
	if canvasLayer:
		canvasLayer.crosshairChange(is_change)

func open_store() -> void:
	store_ins = Utils.store.instantiate()
	get_tree().paused = true
	get_tree().current_scene.add_child(store_ins)

func close_store() -> void:
	get_tree().paused = false
	store_ins.queue_free()

func nextLevel():
	now_level += 1
	
func initPlayer():
	player = PlayerDataManager.player.instantiate()
	get_tree().current_scene.add_child(player)
	player.global_position = player_init_postion
	
func initBoss():
	boss = BossDataManager.getBoss().instantiate()
	get_tree().current_scene.add_child(boss)
	boss.global_position = boss_init_postion

func initGame():
	print("初始化游戏")
	if !player:
		initPlayer()
	else:
		player.global_position = player_init_postion
	initBoss()
	
