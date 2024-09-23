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


var target_player:Player = Utils.player
var state_array = []
var hit = false
var is_die = false
var is_flip
var is_atk = false

var death_callback :Callable


func _ready():
	var node = Node2D.new()
	node.name = "EffectRoot"
	add_child(node)
	name = str(Time.get_ticks_usec())
	hurtBoxComponent.hurt.connect(hurted)
	#audio_hit.stream = load("res://audio/body_hit_finisher_52.wav")


func setData(data):
	SPEED = data['speed']
	hurt = data['hurt']
	HP = data['hp']
	knockback_def = 5

func _physics_process(delta):
	#if Engine.get_physics_frames() % 60 :
	if is_atk || is_die:
		return
	if hit:
		move_and_slide()
	elif target_player != null:
		var next_path_position = target_player.global_position
		#var next_path_position = navigationAgent2D.get_next_path_position()
		var current_agent_position: Vector2 = global_position
		var new_velocity: Vector2 = current_agent_position.direction_to(next_path_position) * SPEED
		_on_velocity_computed(new_velocity)

	if velocity != Vector2.ZERO:
		anim.play("run")
		if velocity.x > 0:
			flip_h(false)
		elif velocity.x < 0 && scale.x == 1:
			flip_h(true)
	else:
		anim.play("idle")

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if state_array.has(Utils.STATE_TYPE.STUN):
		anim.play("idle")
		return
	velocity = safe_velocity
	move_and_slide()

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
	

func flip_h(flip:bool):
	if is_flip == flip:
		return
	is_flip = flip
	var x_axis = sprite_body.global_transform.x
	sprite_body.global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)


func onDie(is_death_effect = true):
	is_die = true
	PlayerDataManager.player_exp += 1
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
	#anim.play("die")
	get_tree().create_tween().tween_property(get_node("角色阴影"),"scale",Vector2.ZERO,0.3)
	#await anim.animation_finished
	queue_free()
	
func setDeathCallBack(death_callback:Callable):
	self.death_callback = death_callback

func addEffect(node):
	get_node("EffectRoot").add_child(node)
