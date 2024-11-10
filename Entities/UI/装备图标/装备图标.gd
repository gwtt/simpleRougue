extends Control
@onready var item_icon: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var item_name: LabelAutoSizer = $MarginContainer/VBoxContainer/HBoxContainer/LabelAutoSizer
@onready var item_type: RichTextLabel = %type
@onready var description: RichTextLabel = $"%description"

signal buy
var item:Item


func _on_animated_button_pressed() -> void:
	buy.emit()
	print("购买成功")
	item.use()
	item.now_use()
	
func set_item(item:Item) -> void:
	item_icon.set_texture(item.item)
	item_name.set_text(item.item_name)
	item_type.set_text("类型:[color=yellow]"+item.type)
	description.set_text(item.description)
	self.item = item
