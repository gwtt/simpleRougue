extends CharacterBody2D
class_name Player
@onready var body = $"身体"
@onready var 头 = $"身体/头"
@onready var 身子 = $"身体/身子"
@onready var 右手 = $"身体/右手"
@onready var 左手 = $"身体/左手"
@onready var 遮挡部分 = $"检测遮挡"
@onready var run_pariticle = $"跑步效果"
@onready var weapon = $"WeaponRoot"
@export var ghost_node:PackedScene
@onready var dash_timer: Timer = $dashTimer
@onready var state_chart: StateChart = $StateChart

var look_dir = null
var gun = null
var SPEED = 200.0
var is_dead = false #是否死亡
var is_knockback = false #后坐力
var knockback_speed = 0 #后坐力速度
var direction:Vector2
func _init() -> void:
	PlayerDataManager.onHpChange.connect(self.onHpChange)
	PlayerDataManager.playerWeaponListChange.connect(self.playerWeaponListChange)
	SkillDataManager.onDash.connect(self.onDashChange)
func _ready():
	Utils.player = self
	var temp = Utils.weapon_list["0"].instantiate()
	PlayerDataManager.add_weapon(Utils.weapon_list["0"].instantiate())
	
func _physics_process(delta):
	if is_dead:
		return
	direction = Input.get_vector("left", "right", "up", "down")
	#if is_knockback:
		#if direction != Vector2.ZERO && SPEED < knockback_speed:
			#velocity = (SPEED - knockback_speed) * global_position.direction_to(get_global_mouse_position())
		#else:
			#velocity = -knockback_speed * global_position.direction_to(get_global_mouse_position())
	changeAnim(direction)	
	if gun:
		gun.look_at(get_global_mouse_position())
		setLookat(get_global_mouse_position())
func changeAnim(direction):
	if direction != Vector2.ZERO:
		state_chart.send_event("idle_to_run")
	else:
		state_chart.send_event("run_to_idle")
	
func animPlay(anim_name,speed = 1.0,is_back = false):
	if 头.animation != anim_name:
		头.play(anim_name,speed,is_back)
	if 身子.animation != anim_name:
		身子.play(anim_name,speed,is_back)
	if 右手.animation != anim_name:
		右手.play(anim_name,speed,is_back)
	if 左手.animation != anim_name:
		左手.play(anim_name,speed,is_back)	

func setLookat(dir):
	if dir != null:
		look_dir = weapon.global_position + (dir * 1000)
		if dir.x > position.x && body.scale.x != 1:
			body.scale.x = 1
		elif dir.x < position.x && body.scale.x != -1:
			body.scale.x = -1
	else:
		look_dir = null

func stateSendEvent(name:String):
	state_chart.send_event(name)
		
func playerWeaponListChange():
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
			var num = node.call("beforePlayerHit",hurt)
			temp_hurt += num
	hurt += temp_hurt
	if hurt < 1:
		hurt = 1
	PlayerDataManager.player_hp -= hurt
	Utils.showHitLabel(hurt,self)
	get_tree().call_group("control","hit")
	#Utils.freeze_frame = true
	Utils.freezeFrame(0.1)
	for node in nodes:
		if node.connect_afterPlayerHit:
			node.call("afterPlayerHit",hurt)		
				
func onHpChange(hp,max_hp):
	if hp <= 0:
		state_chart.send_event("to_die")

func onDashChange():
	state_chart.send_event("toDash")

func onSpeedChange(speed):
	SPEED = speed
	
func cameraSnake(step):
	get_tree().call_group("camera","shootShake",step)
	
func add_ghost()->void:
	var ghost = ghost_node.instantiate()
	ghost.set_property(global_position,body,scale)
	get_parent().add_child(ghost)

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
		shader.set_shader_parameter("alpha",0.65)
	pass

func _on_检测遮挡_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is BaseEnemy:
		return
	var cellCroods = body.get_coords_for_body_rid(body_rid)
	var 材质 = body.get_cell_tile_data(cellCroods).material
	if 材质 != null:
		var shader = 材质 as ShaderMaterial
		shader.set_shader_parameter("alpha",0)
	pass

func _on_dash_timer_timeout() -> void:
	add_ghost()

func _on_idle_state_processing(delta: float) -> void:
	animPlay("idle")
	
func _on_run_state_processing(delta: float) -> void:
	velocity = direction * (SPEED + PlayerDataManager.移速加成)
	changeAnim(direction)
	animPlay("run")
	move_and_slide()
	
func _on_dash_state_processing(delta: float) -> void:
	velocity = direction * (SPEED + PlayerDataManager.移速加成)
	velocity = direction * 1200
	changeAnim(direction)
	move_and_slide()

func _on_dash_state_entered() -> void:
	dash_timer.start()
	await get_tree().create_timer(0.2).timeout
	state_chart.send_event("toNotDash")
	dash_timer.stop()

func _on_die_state_processing(delta: float) -> void:
	is_dead = true
	animPlay("die")
