extends Node

@onready var map: Node2D = $"../一号地图"
 
func _on_1号传送门_body_entered(_body: Node2D) -> void:
	map.start()
