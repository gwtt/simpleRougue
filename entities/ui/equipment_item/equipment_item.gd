extends Control
@onready var item_icon: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var item_name: LabelAutoSizer = $MarginContainer/VBoxContainer/HBoxContainer/LabelAutoSizer
@onready var item_type: RichTextLabel = %type
@onready var description: RichTextLabel = $"%description"

var current_item:Item


func _on_animated_button_pressed() -> void:
	if (PlayerDataManager.gold < current_item.cost):
		GlobalControl.showToast("金币不足",2)
	else:
		PlayerDataManager.gold -= current_item.cost
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
