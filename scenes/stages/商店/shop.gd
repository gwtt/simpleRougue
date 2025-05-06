class_name Shop
extends ColorRect

@onready var item_list = %装备
@onready var refresh: Button = %Refresh
@onready var current_gold: Label = %当前金币
@export var player_stats: PlayerStats
@export var item_pool: ItemPool
@onready var player_detail: RichTextLabel = %player_detail

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
	_on_player_stats_changed()
	
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

# 关闭商店
func _on_next_pressed() -> void:
	self.visible = false

## 当玩家属性改变的时候
func _on_player_stats_changed() -> void:
	# 获取玩家的细节文本
	player_detail.text = player_stats._print_all()
	
	# 如果没有足够金币，将当前选择界面下的购买按钮和刷新按钮disabled
	current_gold.text = str(player_stats.gold)
	var has_enough_gold := player_stats.gold >= 100
	refresh.disabled = !has_enough_gold
	for child in item_list.get_children():
		child.buy_button.disabled = !has_enough_gold

## 当商店打开
func on_visibility_changed() -> void:
	if is_visible_in_tree():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Utils.cross_hair_change(false)
		print("打开商店")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		Utils.cross_hair_change(true)
		print("关闭商店")

func _on_buy_item() -> void:
	pass
