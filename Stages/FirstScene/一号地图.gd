extends Node2D


@onready var player_init_postion = $player_init_position
@onready var boss_init_postion = $boss_init_position
@onready var phantom_camera_2d = $PhantomCamera2D
func _ready():
	Utils.player_init_postion = player_init_postion.global_position
	Utils.boss_init_postion = boss_init_postion.global_position
	Utils.initGame()
	phantom_camera_2d.follow_target = Utils.player

