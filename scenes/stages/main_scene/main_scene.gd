extends Node2D

@onready var camera_2d = $Camera2D
var scaleNum = 1
var array = [[960,540],[960,1620]]
var array_position = PackedVector2Array(array)

# Called when the node enters the scene tree for the first time.
func _ready(): 
	camera_2d.zoom = Vector2(scaleNum,scaleNum)  
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
