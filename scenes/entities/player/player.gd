extends CharacterBody2D
class_name Player

@onready var weapon = $"WeaponRoot"
@onready var player_animations: PlayerAnimations = %PlayerAnimations
@onready var player_skill: PlayerSkill = %PlayerSkill
@onready var player_state: PlayerState = %PlayerState

var controller: AbstractController = AbstractController.new()
var gun = null
var SPEED = 200
var is_knockback = false # 后坐力
var knockback_speed = 0 # 后坐力速度
var direction: Vector2

func _ready():
	controller.set_architecture(SimpleArchitecture.interface(SimpleArchitecture))
	controller.register_event("change_player_weapon_list", self.playerWeaponListChange)
	controller.get_model(PlayerModel).player_weapon_list.value = Utils.weapon_list["0"].instantiate()
	Utils.player = self

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	player_state.changeAnim(direction)
	player_animations.set_look_at(get_global_mouse_position())
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
		
func onHit(hurt):
	var nodes = get_tree().get_nodes_in_group("reward")
	var temp_hurt = 0
	for node in nodes:
		if node.connect_beforePlayerHit:
			var num = node.call("beforePlayerHit", hurt)
			temp_hurt += num
	hurt += temp_hurt
	if hurt < 1:
		hurt = 1
	PlayerDataManager.player_hp -= hurt
	Utils.showHitLabel(hurt, self)
	get_tree().call_group("control", "hit")
	#Utils.freeze_frame = true
	Utils.freezeFrame(0.1)
	for node in nodes:
		if node.connect_afterPlayerHit:
			node.call("afterPlayerHit", hurt)
				
func onHpChange(hp, max_hp):
	PlayerDataManager.onHpChange.emit(hp, max_hp)
	if hp <= 0:
		player_state.stateSendEvent("to_die")

func onSpeedChange(speed):
	SPEED = speed
	
func cameraSnake(step):
	get_tree().call_group("camera", "shootShake", step)
	

func _on_检测遮挡_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
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

func _on_检测遮挡_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is BaseEnemy:
		return
	var cellCroods = body.get_coords_for_body_rid(body_rid)
	var 材质 = body.get_cell_tile_data(cellCroods).material
	if 材质 != null:
		var shader = 材质 as ShaderMaterial
		shader.set_shader_parameter("alpha", 0)
	pass
