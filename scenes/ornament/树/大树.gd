extends Sprite2D

## 子节点主要有两个部分，一个用来判断是否透明显示的area，另一个是阻挡玩家的block

@onready var judge_area: Area2D = %judge_area

func _ready() -> void:
	judge_area.area_entered.connect(on_area_entered)
	judge_area.area_exited.connect(on_area_exited)

# 自身半透明
func on_area_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.5, 0.2)


# 自身不透明
func on_area_exited(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.2)
