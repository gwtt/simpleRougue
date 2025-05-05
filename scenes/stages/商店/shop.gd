class_name Shop
extends ColorRect

@onready var item_list = %装备
@onready var refresh: Button = %Refresh
@onready var current_gold: Label = %当前金币
@export var player_stats: PlayerStats
@export var item_pool: ItemPool
var choose_id = null
var item_list_index

const item_icon = preload("uid://bniaqlyuyi5c4")

func _ready() -> void:
	item_pool.generate_item_pool()
	visibility_changed.connect(on_visibility_changed)
	player_stats.changed.connect(_on_player_stats_changed)
	for child in item_list.get_children():
		child.queue_free()
	on_visibility_changed()	
	refresh_shop()
	
func refresh_shop():
	for i in 4:
		var rarity := player_stats.get_random_rarity_for_level()
		var new_item: ItemIcon = item_icon.instantiate()
		new_item.item_stats = item_pool.get_random_unit(rarity)
		new_item.buy_item.connect(_on_buy_item)
		item_list.add_child(new_item)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()

func _on_refresh_pressed() -> void:
	print("刷新一次商店")
	player_stats.gold = player_stats.gold - 100
	for child in item_list.get_children():
		child.queue_free()
	refresh_shop()

# 关闭商店，并且初始化角色状态，开始下一波
func _on_next_pressed() -> void:
	self.visible = false
	pass


func _on_player_stats_changed() -> void:
	current_gold.text = str(player_stats.gold)
	var has_enough_gold := player_stats.gold >= 100
	## 如果没有足够金币，将当前选择界面下的购买按钮和刷新按钮disabled
	refresh.disabled = !has_enough_gold
	for child in item_list.get_children():
		child.buy_button.disabled = !has_enough_gold

## 当商店打开
func on_visibility_changed() -> void:
	if is_visible_in_tree():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Utils.cross_hair_change(false)
		print("刷新一次商店")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		Utils.cross_hair_change(true)
		print("关闭商店")

func _on_buy_item() -> void:
	pass
