class_name Afterimage extends Polygon2D
@export var points:PackedVector2Array
@export_range(1,100) var length:int
@export_range(1,100) var smooth:int=1
@export var trail_color: Array[Gradient] # 颜色渐变
var old_transform:Transform2D
@export var attack_area: CollisionPolygon2D
@export var sword: Node2D

var target_transform: Transform2D
func _ready() -> void:
	colored(trail_color)
	
func get_total_length()->int:
	return length*smooth
	
func _enter_tree():
	var size:=points.size()
	for i in get_total_length()-1:
		var j:=size*i
		for k in size-1:
			var a:=j+k
			var b:=a+1
			var c:=a+size
			polygons.append([a,b,c])
			polygons.append([c,b,c+1])
			
func colored(gradients:Array[Gradient]):
	var array:PackedColorArray=[]
	var size=get_total_length()
	for i in size:
		var j=float(i)/(size-1)
		for gradient in gradients:
			array.append(gradient.sample(j))
	vertex_colors=array
	
func _physics_process(_delta):
	## 如果不在攻击，取之前的target_transform
	target_transform = sword.transform
	#if sword.is_attack:
		#target_transform = sword.transform
	transform = target_transform.affine_inverse()
	attack_area.transform = target_transform.affine_inverse()
	var array:PackedVector2Array=[]
	for i in smooth:
		var new_transform:=target_transform.interpolate_with(old_transform,float(i)/smooth)
		array.append_array(new_transform * points)
	old_transform=target_transform
	array.append_array(polygon)
	array.resize(get_total_length() * points.size())
	polygon = array.duplicate()
	if attack_area != null:
		attack_area.set_polygon(array.duplicate())
