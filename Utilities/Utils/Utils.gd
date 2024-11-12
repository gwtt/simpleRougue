extends Node

signal onGameStart

var canvasLayer:CanvasLayer
var pause_state = false #暂停状态
var is_game_start = false #游戏是否开始
var player:Player
var boss:BaseEnemy
var freeze_frame = false
enum GUN_CHANGE_TYPE { #切枪类型
	CHANGE, #切换枪械
	RELOAD #切换子弹
}
var store = preload("res://Entities/UI/store/选择界面.tscn")

var weapon_list = {
	"0" = preload("res://Entities/Gun/CustomGun/CustomGun.tscn"),
}
var temp_am_list = []
var am_dict = {
	"0" = preload("res://Entities/BaseWeapon/攻击之爪/ClawsOfAttack.tscn"),
	"1" = preload("res://Entities/BaseWeapon/攻速手套/AttackSpeed​​Gloves.tscn"),
	"2" = preload("res://Entities/BaseWeapon/生命护符/LifeAmulet.tscn"),
	"3" = preload("res://Entities/BaseWeapon/移速手套/BootsOfSpeed.tscn"),
}
const hitlabel = preload("res://Entities/UI/DamageShow/伤害显示.tscn")
	
func gameStart():
	is_game_start = true
	emit_signal("onGameStart")
	
func showHitLabel(num,target:Node2D):
	var ins = hitlabel.instantiate()
	ins.setNumber(num)
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
func getTempAmList():
	if temp_am_list.is_empty():
		var temp = am_dict.keys().duplicate()
		for i in temp.size():
			temp_am_list.append(temp[i])
	return temp_am_list
	
func showToast(msg,time = 1):
	if canvasLayer:
		canvasLayer.showToast(msg,time)

func crosshairChange(is_change):
	if canvasLayer:
		canvasLayer.crosshairChange(is_change)
