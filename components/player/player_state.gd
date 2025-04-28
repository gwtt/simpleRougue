class_name PlayerState
extends Node

## 用来控制玩家状态和移动
@export var player: Player
@onready var state_chart: StateChart = %StateChart
@onready var idle: AtomicState = %idle
@onready var run: AtomicState = %run
@onready var die: AtomicState = %die
@onready var hurt: AtomicState = %hurt
@onready var dash: AtomicState = %dash
@onready var not_dash: AtomicState = %notDash
@onready var player_animations: PlayerAnimations = %PlayerAnimations
@onready var player_skill: PlayerSkill = %PlayerSkill

func _ready() -> void:
	idle.state_physics_processing.connect(on_idle_physics_processing)
	run.state_physics_processing.connect(on_run_physics_processing)
	die.state_entered.connect(on_die_entered)
	hurt.state_entered.connect(on_hurt_entered)
	dash.state_entered.connect(on_dash_entered)
	dash.state_physics_processing.connect(on_dash_physics_processing)
	
func stateSendEvent(name: String):
	state_chart.send_event(name)

func changeAnim(move_direction):
	if move_direction != Vector2.ZERO:
		stateSendEvent("idle_to_run")
	else:
		stateSendEvent("run_to_idle")

## 闲置状态
func on_idle_physics_processing(_delte):
	player_animations.anim_play("idle")

## 跑步状态
func on_run_physics_processing(_delte):
	player.velocity = player.direction * (player.SPEED + PlayerDataManager.移速加成)
	changeAnim(player.direction)
	player_animations.anim_play("run")
	player.move_and_slide()

## 死亡状态进入
func on_die_entered():
	player_animations.anim_play("die")

## 受伤状态进入
func on_hurt_entered():
	player_animations.anim_play("hurt")
	player_animations.anim_finished.connect(func():stateSendEvent("hurt_to_idle"))

## 冲锋状态进入
func on_dash_entered():
	player_skill.dash()

## 冲锋状态
func on_dash_physics_processing(_delte):
	player.velocity = player.direction * (player.SPEED + PlayerDataManager.移速加成)
	player.velocity = player.direction * 1200
	changeAnim(player.direction)
	player.move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_released("dash"):
		stateSendEvent("to_dash")
	
