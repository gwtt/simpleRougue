extends TextureRect
const wi_pre = preload("res://Entities/WeaponItem/装备图标.tscn")
@onready var shop_am_list = $ScrollContainer/HBoxContainer
@onready var dialog = $Control
@onready var dilaog_label = $Control/TextureRect/Label
@onready var tip = $提示
@onready var player = $AudioStreamPlayer2D

var choose_id = null
var choose_am : 基础装备= null

func _enter_tree():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _exit_tree():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _ready() -> void:
	loadAmList()
	tip.visible = false
	dialog.visible = false

func loadAmList():
	for item in shop_am_list.get_children():
		item.queue_free()
	for item in Utils.getTempAmList():
		var ins = wi_pre.instantiate()
		shop_am_list.add_child(ins)
		ins.setAmData(item)
		ins.mouseEvent.connect(self.mouseEvent)
		ins.onAmClick.connect(self.onAmClick)


func onAmClick(id,am:基础装备):
	choose_id = id
	choose_am = am
	dialog.visible = true
	dilaog_label.text = tr("确认购买") + tr(am.装备名称)

func _on_button_pressed() -> void:
	dialog.visible = false
	if choose_am != null:
		if PlayerDataManager.gold >= choose_am.装备价格:
			PlayerDataManager.gold-= choose_am.装备价格
			PlayerDataManager.添加装备(Utils.am_dict[choose_id].instantiate())
			Utils.showToast("购买成功")
		else:
			Utils.showToast("购买失败")
	elif choose_id != null:
		if PlayerDataManager.gold >= Utils.weapon_money_list[choose_id]:
			PlayerDataManager.gold-= Utils.weapon_money_list[choose_id]
			PlayerDataManager.add_weapon(Utils.weapon_list[choose_id].instantiate())
			Utils.showToast("购买成功")
		else:
			Utils.showToast("购买失败")

func _on_button_2_pressed() -> void:
	dialog.visible = false
	choose_id = null
	choose_am = null

func mouseEvent(show,am):
	tip.visible = show
	if am != null:
		tip.setData(am)

#关闭
func _on_button_3_pressed() -> void:
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
