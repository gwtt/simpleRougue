extends CharacterBody2D
class_name Player

@export var player_stats: PlayerStats
@onready var weapon = $"WeaponRoot"
@onready var player_animations: PlayerAnimations = %PlayerAnimations
@onready var player_skill: PlayerSkill = %PlayerSkill
@onready var player_state: PlayerState = %PlayerState

var gun = null
var SPEED = 200
var is_knockback = false # 后坐力
var knockback_speed = 0 # 后坐力速度
var direction: Vector2

func _ready():
	var local_gun = Utils.weapon_list["0"].instantiate() as BaseGun
	PlayerDataManager.player_weapon_list[0] = local_gun
	local_gun.name = str(1)
	weapon.add_child(local_gun)
	local_gun.setOwner(self)
	if gun == null:
		gun = local_gun
		gun.set_use(true)

	Utils.player = self

func _physics_process(_delta):
	# 移动
	direction = Input.get_vector("left", "right", "up", "down")
	player_state.changeAnim(direction)
	player_animations.set_look_at(get_global_mouse_position())
	# 如果有武器
	if gun:
		gun.look_at(get_global_mouse_position())	
		
func playerWeaponListChange(_new_value):
	for weapon_id in PlayerDataManager.player_weapon_list:
		if !weapon.has_node(str(weapon_id)):
			var local_gun = PlayerDataManager.player_weapon_list[weapon_id] as BaseGun
			local_gun.name = str(weapon_id)
			weapon.add_child(local_gun)
			local_gun.setOwner(self)
			if gun == null:
				gun = local_gun
				gun.set_use(true)
				
func changeWeapon(weapon_id):
	for item in weapon.get_children():
		item.set_use(item.name == str(weapon_id))
		
func onSpeedChange(speed):
	SPEED = speed
	
func cameraSnake(step):
	get_tree().call_group("camera", "shootShake", step)
	
func _on_检测遮挡_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	#获取图块坐标
	if body is BaseEnemy or body is Player:
		return
	var cellCroods = body.get_coords_for_body_rid(body_rid)
	##获取图集坐标
	#var atlasCroods = body.get_cell_atlas_coords(2,cellCroods)
	##获取图集资源
	#var tileSetAtlasSource= body.tile_set.get_source(0) as TileSetAtlasSource
	##获取图集中图块的占用单元格尺寸
	#var size = tileSetAtlasSource.get_tile_size_in_atlas(atlasCroods)
	#获取图块材质
	var 材质 = body.get_cell_tile_data(cellCroods).material
	if 材质 != null:
		var shader = 材质 as ShaderMaterial
		shader.set_shader_parameter("alpha", 0.65)
	pass

func _on_检测遮挡_body_shape_exited(body_rid, body, _body_shape_index, _local_shape_index):
	if body is BaseEnemy:
		return
	var cellCroods = body.get_coords_for_body_rid(body_rid)
	var 材质 = body.get_cell_tile_data(cellCroods).material
	if 材质 != null:
		var shader = 材质 as ShaderMaterial
		shader.set_shader_parameter("alpha", 0)
	pass

## 进入关卡时恢复所有状态
func init_game():
	player_stats.current_hp = player_stats.max_hp
	player_stats.current_xp = player_stats.max_xp
