class_name ItemIcon
extends NinePatchRect
@onready var item_icon: TextureRect = %item_icon
@onready var item_name: Label = %item_name
@onready var item_type: RichTextLabel = %item_type
@onready var description: RichTextLabel = $"%description"
@export var player_stats: PlayerStats
@onready var buy_button: Button = $BuyButton
@export var item_stats: PandoraEntity : set = _set_item_stats
var current_item:Item
signal buy_item

func _on_animated_button_pressed() -> void:
	player_stats.gold -= item_stats.get_integer("cost")
	player_stats.player_item_list.append(item_stats)
	Utils.add_to_player(item_stats, player_stats)
	buy_item.emit()
	print("购买成功")
	#current_item.use()
	#current_item.now_use()
	
func set_item(item:Item) -> void:
	item_icon.set_texture(item.item)
	item_name.set_text(item.item_name)
	item_type.set_text("类型:[color=yellow]"+item.type)
	description.set_text(item.description)
	self.current_item = item
 
## 初始化装备信息
func _set_item_stats(value: PandoraEntity) -> void:
	if value == null:
		return
	if not is_node_ready():
		await ready
	self.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_icon.texture = value.get_resource("item_texture")
	item_name.text = value.get_string("item_name")
	item_type.text = value.get_string("type")
	description.text = value.get_string("description")
	item_stats = value
