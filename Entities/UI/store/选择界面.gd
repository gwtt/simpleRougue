extends CanvasLayer
@onready var show = $show


var choose_id = null
var choose_am : 基础装备= null
var item_list_index


func _ready() -> void:
	PlayerDataManager.buy.connect(_refresh)
	_refresh(true)
	
func _refresh(first_time = false):
	if PlayerDataManager.gold < 100 && !first_time:
		GlobalControl.showToast("金币不足",2)
		return
	if !first_time:
		PlayerDataManager.gold -= 100
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

# 关闭商店，并且初始化角色状态，开始下一波
func _on_next_pressed() -> void:
	Utils.initGame()
	Utils.close_store()
