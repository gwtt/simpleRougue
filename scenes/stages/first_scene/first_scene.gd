extends Node2D


@onready var player_init_postion = $player_init_position
@onready var boss_init_postion = $boss_init_position

func _ready():
	Utils.boss_init_postion = boss_init_postion.global_position
	Utils.player_init_postion = player_init_postion.global_position

func start():
	Utils.initGame()
