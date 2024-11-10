extends TextureRect
@onready var show = $show


var choose_id = null
var choose_am : 基础装备= null
var item_list_index
func _enter_tree():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _exit_tree():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _ready() -> void:
	_refresh()
	pass


func onAmClick(id,am:基础装备):
	choose_id = id
	choose_am = am

func _on_button_pressed() -> void:
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
	choose_id = null
	choose_am = null


#关闭
func _on_button_3_pressed() -> void:
	queue_free()

func _refresh():
	item_list_index = ItemManager.getShopList(true)
	# 固定四个位置
	var i = 0
	for index in item_list_index:
		show.get_child(i).set_item(ItemManager.item_list[index].instantiate())
		i=i+1
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()


func _on_refresh_pressed() -> void:
	print("刷新一次商店")
	_refresh()
