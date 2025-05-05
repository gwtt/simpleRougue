class_name ItemIcon
extends Panel
@onready var item_icon: TextureRect = %item_icon
@onready var item_name: Label = %item_name
@onready var item_type: RichTextLabel = %item_type
@onready var description: RichTextLabel = $"%description"
@export var player_stats: PlayerStats
@onready var buy_button: Button = $BuyButton
@export var item_stats: ItemStats : set = _set_item_stats
var current_item:Item
signal buy_item

func _on_animated_button_pressed() -> void:
	player_stats.gold -= current_item.cost
	buy_item.emit()
	PlayerDataManager.buy.emit(current_item)
	print("购买成功")
	current_item.use()
	current_item.now_use()
	
func set_item(item:Item) -> void:
	item_icon.set_texture(item.item)
	item_name.set_text(item.item_name)
	item_type.set_text("类型:[color=yellow]"+item.type)
	description.set_text(item.description)
	self.current_item = item
 
## 初始化装备信息
func _set_item_stats(value: ItemStats) -> void:
	if not is_node_ready():
		await ready
	self.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_icon.texture = value.item
	item_name.text = value.item_name
	item_type.text = value.type
	description.text = value.description
	item_stats = value
