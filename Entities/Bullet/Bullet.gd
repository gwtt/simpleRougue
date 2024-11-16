extends CharacterBody2D
class_name Bullet

@export var hitBoxComponent:HitBoxComponent
@export var bullet_impact:PackedScene
@export var bullet_smoke:PackedScene

@export var hurt = 1.0
@export var speed = 600
@export var knockback_speed = 50
@export var knockback_time = 0.1


var player:Player
var gun:BaseGun

var timer = Timer.new()
var queue_time = 0
func _ready():
	hitBoxComponent.hit.connect(_hit)
	set_process(false)
	get_tree().create_tween().set_ease(Tween.EASE_OUT_IN).tween_property(self,"scale",Vector2(1.2,1.2),0.1).from(Vector2(0.5,1.5))
	add_child(timer)
	timer.timeout.connect(self._on_timer_timeout)
	timer.start(0.05)
	z_index = 0

func setOnwer(_player):
	self.player = _player

func start(local:Vector2,pos:Vector2):
	global_position = local
	velocity = local.direction_to(pos)

func fire():
	hurt += PlayerDataManager.基础伤害
	velocity = Vector2(speed, 0).rotated(rotation)
	set_process(true)
	
	#var ins = bullet_shell.instantiate()
	#ins.global_position = global_position - Vector2(10,0) * velocity.normalized()
	#get_tree().root.add_child(ins)
	#ins.start(velocity / 2)
	

func _process(delta):
	#if Utils.freeze_frame:
	#	delta = 0.0
	var collisionResult = move_and_collide(velocity * delta)
	if collisionResult:
		_hit(collisionResult)

func _hit(collisionResult)->void:
	bulletSmoke(collisionResult)
	queue_free()

func _on_timer_timeout():
	z_index = 35
	queue_time += 0.05
	if queue_time > 0.5:
		queue_free()

func bulletSmoke(collisionResult):
	var ins = bullet_smoke.instantiate()
	get_parent().add_child(ins)
	if collisionResult is KinematicCollision2D:
		ins.global_position = collisionResult.get_position()
	else:
		ins.global_position = collisionResult.get_global_position()
	ins.look_at(player.get_global_position())
	#
	#var imapct = bullet_impact.instantiate()
	#get_parent().add_child(imapct)
	#imapct.global_position = collisionResult.get_position()
	#imapct.rotation = collisionResult.get_normal().angle()
	
