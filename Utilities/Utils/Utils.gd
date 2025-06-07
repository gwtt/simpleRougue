extends Node

signal onGameStart()
# UI
var now_level = 1 #当前关卡
var shake = 1.0 #振动幅度
var canvasLayer:CanvasLayer
# 光标
var cursor: TextureRect
var pause_state = false #暂停状态
var is_game_start = false #游戏是否开始
var player:Player
var boss
var freeze_frame = false
var player_init_postion = Vector2.ZERO
var boss_init_postion = Vector2.ZERO
enum GUN_CHANGE_TYPE { #切枪类型
	CHANGE, #切换枪械
	RELOAD #切换子弹
}

var weapon_list = {
	"0" = preload("res://entities/gun/custom_gun/custom_gun.tscn"),
	"1" = preload("res://scenes/entities/sword/sword.tscn")
}
var temp_am_list = []

const hitlabel = preload("res://entities/ui/damage_show/damage_show.tscn")
	
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

## 设置旋转光标状态
func cross_hair_change(status: bool):
	if status:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		pause_node(player, true)
		GameManager.ui_active = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause_node(player, false)
		GameManager.ui_active = true
	if !cursor:
		cursor = get_tree().get_first_node_in_group("cursor")
	cursor.visible = status

func nextLevel():
	now_level += 1
	
func initPlayer():
	player = PlayerDataManager.player.instantiate()
	get_tree().current_scene.add_child(player)
	player.global_position = player_init_postion
	
func initBoss():
	boss = BossDataManager.getBoss().instantiate()
	get_tree().current_scene.call_deferred("add_child", boss)
	boss.global_position = boss_init_postion

func initGame():
	print("初始化游戏")
	if !player:
		initPlayer()
	else:
		player.global_position = player_init_postion
		player.init_game()
	initBoss()
	
## 将节点的physics_process状态改变
func pause_node(node, status:bool):
	node.set_physics_process(status)
	for child in node.get_children():
		if child.has_method("set_physics_process"):
			pause_node(child, status)

## 添加装备属性到玩家
func add_to_player(pandora: PandoraEntity, player_stats: PlayerStats):
	player_stats.move_speed += pandora.get_integer("move_speed")
	player_stats.attack_speed += pandora.get_integer("attack_speed")
	player_stats.base_damage += pandora.get_integer("base_damage")
	player_stats.luck += pandora.get_integer("luck")
	player_stats.max_hp += pandora.get_integer("hp")
	player_stats.max_xp += pandora.get_integer("xp")
	player_stats.add_attack_probability += pandora.get_float("add_attack_probability")
	player_stats.add_hp_probability += pandora.get_float("add_hp_probability")
	player_stats.add_mp_probability += pandora.get_float("add_mp_probability")
	player_stats.add_coin_probability += pandora.get_float("add_coin_probability")
	player_stats.add_exp_probability += pandora.get_float("add_exp_probability")

## 减去装备属性到玩家
func minus_to_player(pandora: PandoraEntity, player_stats: PlayerStats):
	player_stats.move_speed -= pandora.get_integer("move_speed")
	player_stats.attack_speed -= pandora.get_integer("attack_speed")
	player_stats.base_damage -= pandora.get_integer("base_damage")
	player_stats.luck -= pandora.get_integer("luck")
	player_stats.max_hp -= pandora.get_integer("hp")
	player_stats.max_xp -= pandora.get_integer("xp")
	player_stats.add_attack_probability -= pandora.get_float("add_attack_probability")
	player_stats.add_hp_probability -= pandora.get_float("add_hp_probability")
	player_stats.add_mp_probability -= pandora.get_float("add_mp_probability")
	player_stats.add_coin_probability -= pandora.get_float("add_coin_probability")
	player_stats.add_exp_probability -= pandora.get_float("add_exp_probability")
