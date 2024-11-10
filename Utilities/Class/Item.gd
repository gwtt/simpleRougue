extends Node2D
class_name Item

var item_type_list = {
	"item" = "item",
	"skill" = "skill"
}

# 装备图标
@export var item: Texture
@export var item_name: String
# 装备类型（装备、技能）
@export var type: String
# 描述
@export var description:String
@export var cost = 100
# 天赋技能和装备会立马触发
func now_use():
	pass
	
# 只有技能会触发
func use():
	pass

# 失去后效果
func miss():
	pass
