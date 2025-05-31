extends Control

const weapon_bullet_pre = preload("res://entities/ui/bullet_shell/bullet_shell.tscn")

@onready var change_audio = $AudioStreamPlayer2D
@onready var box_top = $HPUI
@onready var gold_label: Label = %金币
@onready var weapon_bullet_list: HBoxContainer = %BulletHbox
@onready var hp_bar = $HPUI/血条
@onready var level_label: Label = %经验
# Called when the node enters the scene tree for the first time.
var controller = AbstractController.new()

func _ready() -> void:
	controller.set_architecture(SimpleArchitecture.interface(SimpleArchitecture))
	Utils.onGameStart.connect(self.onGameStart)
	PlayerDataManager.onGoldChange.connect(self.onGoldChange)
	PlayerDataManager.onPlayerLevelChange.connect(self.onPlayerLevelChange)
	PlayerDataManager.onWeaponChangeAnim.connect(self.onWeaponChangeAnim) #武器化监听
	EventBus.subscribe("weapon_change_anim", onWeaponChangeAnim) #武器化监听
	EventBus.subscribe("weapon_bullets_change", onWeaponBulletsChange) #武器化监听

	if Utils.player:
		Utils.player.health_component.onHpChange.connect(
			func hpChange(hp,max_hp): #血量变化监听
				hp_bar.max_value = max_hp
				hp_bar.value = hp
		)
func onGameStart():
	onGoldChange(PlayerDataManager.gold)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property(box_top,"position:y",box_top.position.y,0.3).from(box_top.position.y-box_top.size.y)
	show()
	
func onGoldChange(gold):
	gold_label.text = str(gold)

	
func onWeaponChangeAnim(weapon_id,tag = Utils.GUN_CHANGE_TYPE.CHANGE):
	call_deferred("loadWeaponBullets",weapon_id)

func onPlayerLevelChange(level):
	level_label.text = str(level)

func loadWeaponBullets(weapon_id):
	for item in weapon_bullet_list.get_children():
		item.free()
	weapon_bullet_list.get_children().clear()
	var weapon:BaseGun = PlayerDataManager.player_weapon_list[weapon_id]
	var local_count =  weapon.bullets_max_count - weapon.bullets_count
	var index = 1
	for item in weapon.bullets_count:
		var ins = weapon_bullet_pre.instantiate()
		ins.name = str(local_count + index)
		weapon_bullet_list.add_child(ins)
		index += 1
func onWeaponBulletsChange(bullet,bullet_max):
	var local_count =  bullet_max - bullet
	if weapon_bullet_list.has_node(str(local_count)):
		weapon_bullet_list.get_node(str(local_count)).destory()
