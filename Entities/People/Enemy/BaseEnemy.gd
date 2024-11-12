extends CharacterBody2D
class_name BaseEnemy

@export var healthComponent:EnemyHealthComponent
@export var hitBoxComponent:EnemyHitBoxComponent
@export var hurtBoxComponent:EnemyHurtBoxComponent
@export var is_boss = false
@export var SPEED = 50.0
@export var hurt = 1
@export var HP = 5
@export var knockback_def = 5 #击退抵抗
var movement_delta: float
var navigationAgent2D := NavigationAgent2D.new()
@onready var sprite_body = get_node("body")
@onready var anim :AnimatedSprite2D = get_node("body/AnimatedSprite2D")
@onready var state_chart: StateChart = $StateChart
var attack_timer = 0 # 计时器
var attack_delay = 1 * 30 # 攻击前摇时间
var target_player:Player
var hit = false
var death_callback :Callable
var attack_speed = 1.0

func _ready():
	var node = Node2D.new()
	node.name = "EffectRoot"
	add_child(node)
	name = str(Time.get_ticks_usec())
	hurtBoxComponent.hurt.connect(hurted)
	healthComponent.onDie.connect(onDie)
	target_player = Utils.player
	Utils.boss = self
	#audio_hit.stream = load("res://audio/body_hit_finisher_52.wav")

func _process(delta: float) -> void:
	attack_timer += 1

func setData(data):
	SPEED = data['speed']
	hurt = data['hurt']
	HP = data['hp']
	knockback_def = 5

func hurted(bullet:Bullet)->void:
	var speed = bullet.knockback_speed - knockback_def
	if speed > 0:
		velocity = -(global_position.direction_to(Utils.player.global_position)) * speed
		hit = true
	#var materialFlash = ShaderMaterial.new()
	#materialFlash.shader = load("res://shader/Monster1.gdshader")
	#sprite_body.get_node("AnimatedSprite2D").material = materialFlash
	await get_tree().create_timer(bullet.knockback_time).timeout.connect(func timeout():
		sprite_body.get_node("AnimatedSprite2D").material = null; hit = false )
	

func onDie(is_death_effect = true):
	print("%s死亡" % [self.name])
	PlayerDataManager.player_exp += 1
	stateSendEvent("to_die")
	if death_callback:
		death_callback.call(self)
	var nodes = get_tree().get_nodes_in_group("reward")
	var temp_hurt = 0
	if is_death_effect:
		for node in nodes:
			if node.connect_kill:
				node.call("onKill",self)
	set_physics_process(false)
	for item in get_node("EffectRoot").get_children():
		item.queue_free()
	get_node("CollisionShape2D").call_deferred("set_disabled",true)
	anim.play("die")
	await anim.animation_finished
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),2)
	await tween.finished
	open_store()
	#await anim.animation_finished
	queue_free()
	
func setDeathCallBack(death_callback:Callable):
	self.death_callback = death_callback

func addEffect(node):
	get_node("EffectRoot").add_child(node)

func stateSendEvent(name:String):
	state_chart.send_event(name)

func open_store() -> void:
	var store = Utils.store.instantiate()
	get_tree().paused = true
	get_tree().current_scene.add_child(store)
