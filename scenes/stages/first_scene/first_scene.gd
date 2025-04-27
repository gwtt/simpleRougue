extends Node2D


@onready var player_init_postion = $player_init_position
@onready var boss_init_postion = $boss_init_position
@onready var phantom_camera_2d = $PhantomCamera2D
var controller = AbstractController.new()
func _ready():
	controller.set_architecture(SimpleArchitecture.interface(SimpleArchitecture))
	controller.get_model(PlayerModel).player_init_position = player_init_postion.global_position
	Utils.boss_init_postion = boss_init_postion.global_position
	Utils.player_init_postion = player_init_postion.global_position
	Utils.initGame()
	phantom_camera_2d.follow_target = Utils.player

