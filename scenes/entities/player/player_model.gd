class_name PlayerModel extends AbstractModel

var speed:BindableProperty = BindableProperty.new()
var max_health:BindableProperty = BindableProperty.new()
var health:BindableProperty = BindableProperty.new()
var player_weapon_list:BindableProperty = BindableProperty.new()
var global_postion:Vector2
var player_init_position:Vector2
var player:Player
func on_init():
	init_value()
	init_func()


func init_value():
	speed.value = 200
	max_health.value = 4
	health.value = 4
	player_weapon_list.value = {}
	
func init_func():
	#speed.register(
		#func(new_value):
			#send_event("change_player_speed", new_value)	
	#)
	#
	#max_health.register(
		#func(new_value):
			#send_event("change_player_max_health", new_value)	
	#)
	#
	health.register(
		func(new_value):
			if new_value < 0:
				send_event("player_die", new_value)	
			send_event("change_player_health", new_value)
	)
	player_weapon_list.register(
		func(new_value):
			send_event("change_player_weapon_list", new_value)
	)
	
