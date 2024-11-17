extends Node2D
class_name BaseGun


const particles_pre = preload("res://Entities/GunParticle/CustomParticle/CustomParticle.tscn")

## 武器ID
@export var weapon_id = 0 #枪械ID
@export var image:Texture #枪械图片
@export var weapon_name:String = "Gun" #枪械名称
@export_enum("ASSAULT_RIFLES","SUBMACHINE_GUNSRELOAD","MACHINE_GUNS","SNIPER_RIFLES","SHOTGUNS","LASER_WEAPONS") var weapon_type = "ASSAULT_RIFLES"
@export var bullet_scene : PackedScene #子弹模板
@export var damage = 0.0 #子弹伤害
@export var bullet_speed = 200 #子弹速度
@export var fire_rate = 5.0 #开火速率
@export var bullets_max_count = 10 #子弹数量
@export var change_speed = 1.0 #换弹时间
@export var recoil_duration = 0.2
@export var knockback_speed = 50 #击退速度
@export var knockback_time = 0.1 #击退持续时间
@export var time_scale = 0.1 #帧冻结时间倍数
@export var freeze_frame = 3 #帧冻结帧数
@export var recoil = 0 #后坐力大小
@export var shake_vector = Vector2.ONE * 10 #屏幕晃动大小
@export var reload_stream :AudioStream = load("res://assets/声音/GUNMech_Insert Clip_01.wav")

var attachments = {
	"Optics" = null,
	"Muzzle" = null,
	"Barrel" = null,
	"Underbarrel" = null,
	"Ammunition" = null,
	"Stock" = null,
	"Tactical" = null,
	"Perks" = null
}

@onready var anim_player:AnimationPlayer = $AnimationPlayer
@onready var tip = $Tip
@onready var audio = $AudioStreamPlayer2D
@onready var timer = $shoot_timer
@onready var weapon_image = $Sprite2D

var attachments_node = Node.new()
var attachments_dict = {}
var tween:Tween
var direction:Vector2 #朝向
var player:Player #使用玩家
var is_use = false #是否正在使用
var can_shoot = true #是否可以射击
var bullets_count = 0: #剩余子弹
	set(value):
		bullets_count = value
		if is_use:
			PlayerDataManager.emit_signal("onWeaponBulletsChange",bullets_count,bullets_max_count) 
var is_reloading = false #是否正在换子弹
var change_timer = Timer.new()
var audio_reload_ammo = AudioStreamPlayer.new()

func _init():
	change_timer.one_shot = true
	change_timer.timeout.connect(self.reload_over)
	
func _ready() -> void:
	add_to_group("guns")
	PlayerDataManager.onPlayerFireRateChange.connect(self.onPlayerFireRateChange)
	add_child(attachments_node)
	bullets_count = bullets_max_count
	add_child(change_timer)
	audio_reload_ammo.stream = reload_stream
	add_child(audio_reload_ammo)
	weapon_image.texture = image
	set_use(false)
	timer.wait_time = 1.0 / fire_rate

func onPlayerFireRateChange(rate):
	timer.wait_time = 1.0 / (fire_rate * rate)

#更新枪械配置
func updateGun():
	bullets_max_count = int(bullets_max_count * (1+PlayerDataManager.base_magazine_count))
	timer.wait_time = 1.0 / fire_rate
	PlayerDataManager.emit_signal("onWeaponBulletsChange",bullets_count,bullets_max_count) 


#子弹装填完毕
func reload_over():
	var ammo = bullets_max_count - bullets_count
	if PlayerDataManager.player_ammo < ammo:
		ammo = PlayerDataManager.player_ammo
		PlayerDataManager.player_ammo = 0
	else:
		PlayerDataManager.player_ammo -= ammo
	bullets_count += ammo
	PlayerDataManager.emit_signal("onWeaponChangeAnim",weapon_id,Utils.GUN_CHANGE_TYPE.RELOAD)
	is_reloading = false

#设置枪械所属
func setOwner(player):
	self.player = player

func _process(_delta):
	if Utils.freeze_frame:
		_delta = 0.0
	var mouse_pos = get_global_mouse_position()
	direction = (mouse_pos - tip.global_position).normalized()
	#Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN && 
	if Input.is_action_pressed("shoot") and can_shoot and !is_reloading and player.is_dead == false:
		can_shoot = false
		timer.start()
		if bullets_count > 0:
			_shoot()
		else:
			reload_ammo()
	
	if is_use && Input.is_action_pressed("reload"):
		reload_ammo()

#设置是否正在使用
func set_use(use:bool):
	change_timer.stop()
	is_reloading = false
	is_use = use
	set_physics_process(is_use)
	set_process(is_use)
	visible = is_use
	if player && is_use:
		player.gun = self
		PlayerDataManager.emit_signal("onWeaponChangeAnim",weapon_id)
		if bullets_count == 0:
			reload_ammo()
	PlayerDataManager.emit_signal("onWeaponChanged")

#开火
func fire(bullet:Bullet,is_bullet = true,is_play = true):
	if is_bullet:
		bullets_count -= 1
		if bullets_count < 0:
			can_shoot = false
			bullet.queue_free()
			return
	
	bullet.speed = bullet_speed
	bullet.hurt = damage * (1+PlayerDataManager.伤害加成)
	bullet.knockback_speed = knockback_speed
	bullet.knockback_time = knockback_time
	bullet.gun = self
	if is_bullet:
		bullet.fire()
	if recoil > 0 && is_bullet:
		player.set_knockback(recoil)
	if is_play:
		audio.play()

#切换子弹
func reload_ammo():
	if PlayerDataManager.player_ammo == 0:
		Utils.showToast("AMMO_OUT")
		return 
	if !is_reloading && change_timer.is_stopped() && bullets_count < bullets_max_count:
		is_reloading = true
		var local_speed = change_speed * (1-PlayerDataManager.base_reload_speed) 
		anim_player.speed_scale = 1 / local_speed
		change_timer.start(local_speed)
		audio_reload_ammo.play()
		#playReload()

#播放切换动画
func playReload():
	anim_player.play("reload")

func _physics_process(_delta):
	if Utils.freeze_frame:
		_delta = 0.0
	#if Utils.freeze_frame:
		#if Engine.get_physics_frames() % freeze_frame == 0:
			# 暂停一帧
		#	Utils.freeze_frame = false
			# 将时间比例设置为1
		#	Engine.time_scale = 1
		#	return

func _shoot() -> void:
	call_deferred("_shootAnim")

func _shootAnim():
	player.cameraSnake(shake_vector * direction)
	var ins = particles_pre.instantiate()
	ins.position = tip.position
	add_child(ins)
