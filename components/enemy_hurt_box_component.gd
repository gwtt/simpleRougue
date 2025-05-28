extends Area2D
class_name  EnemyHurtBoxComponent

signal hurt(hitbox)

@export var healthComponent:EnemyHealthComponent
var is_die:bool = false
var audio_hit = AudioStreamPlayer2D.new() #受击音效
var idle_frame_num = 0
func _init() -> void:
	hurt.connect(hitFlash)

func _ready() -> void:
	add_child(audio_hit)
	healthComponent.onDie.connect(toDie)
	
func _physics_process(_delta):
	if idle_frame_num > 0:
		Utils.showHitLabel(idle_frame_num,self)
		idle_frame_num = 0

func toDie()->void:
	is_die = true

func hitFlash(bullet:Bullet):
	if is_die:
		return
	Utils.freezeFrame(bullet.gun.time_scale)
	onHit(bullet.hurt)
	audio_hit.play(0.17)

## 子弹击中
## 根据暴击率计算是否伤害乘积
func onHit(hit_num, _is_show_label = true, _is_death_effect = true):
	if PlayerDataManager.子弹暴击率 > 0 && PlayerDataManager.子弹暴击率 > randi() % 100:
		hit_num *= 1.5
	## 获取buff节点
	var nodes = get_tree().get_nodes_in_group("reward")
	var temp_hurt = 0
	for node in nodes:
		if node.connect_beforeAtk:
			var num = node.call("beforeAtk",self,hit_num)
			temp_hurt += num
	hit_num += temp_hurt
	## 约到两位小数
	hit_num = snapped(hit_num,0.01)
	healthComponent.damage(hit_num)
	for node in nodes:
		if node.connect_afterAtk:
			node.call("afterAtk",self,hit_num)
