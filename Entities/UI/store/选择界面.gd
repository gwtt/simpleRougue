extends CanvasLayer
@onready var show = $show


var choose_id = null
var choose_am : 基础装备= null
var item_list_index
func _enter_tree():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _exit_tree():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _ready() -> void:
	PlayerDataManager.buy.connect(_refresh)
	_refresh()
	
func _refresh(item = null):
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
