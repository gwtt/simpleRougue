class_name ItemStats
extends Resource

enum Rarity {COMMON, UNCOMMON, RARE, LEGENDARY}

## 装备图标
@export var item: Texture
## 装备名字
@export var item_name: String
## 装备类型（装备、技能）
@export var type: String
## 描述
@export var description:String
## 池子里面有多少个
@export var pool_count: int = 1
## 购买花费
@export var cost = 100
## 装备等级
@export_range(0, 100000) var level: int
## 移动速度加成
@export_range(0, 100000) var move_speed: int
## 攻速加成加成
@export_range(0, 100000) var attack_speed: int
## 基础伤害加成
@export_range(0, 10000) var base_damage: int
## 幸运值加成
@export_range(0, 100000) var luck: int
## 最大血量加成
@export_range(0, 10000) var hp: int
## 最大蓝量加成
@export_range(0, 10000) var xp: int
## 防御加成
@export_range(0, 10000) var defense: int
## 暴击率加成（百分比）
@export_range(0, 100) var critical_chance: float
## 暴击伤害加成（百分比）
@export_range(0, 200) var critical_damage: float
## 生命偷取（百分比）
@export_range(0, 100) var life_steal: float
## 生命回复（每秒）
@export_range(0, 1000) var health_regen: int
## 技能冷却缩减（百分比）
@export_range(0, 100) var cooldown_reduction: float
## 经验加成（百分比）
@export_range(0, 500) var exp_bonus: float
## 护甲穿透（百分比）
@export_range(0, 100) var armor_penetration: float
## 射程
@export_range(0, 10000) var range: int

@export_range(0, 100) var add_attack_probability = 0.0 # 增加攻击力概率
@export_range(0, 100) var add_hp_probability = 0.0 # 增加血量概率
@export_range(0, 100) var add_mp_probability = 0.0 # 增加魔法概率
@export_range(0, 100) var add_coin_probability = 0.0 # 增加金币概率
@export_range(0, 100) var add_exp_probability = 0.0 # 增加经验概率
@export_range(0, 100) var add_attack_rate_probability = 0.0 # 增加攻速概率
@export_range(0, 100) var add_range_probability = 0.0 # 增加范围概率
@export_range(0, 100) var add_speed_probability = 0.0 # 增加速度概率
@export_range(0, 100) var add_armor_probability = 0.0 # 增加护甲概率

func add_to_player(player_stats: PlayerStats):
	player_stats.move_speed += move_speed
	player_stats.attack_speed += attack_speed
	player_stats.base_damage += base_damage
	player_stats.luck += luck
	player_stats.max_hp += hp
	player_stats.max_xp += xp
	player_stats.add_attack_probability += add_attack_probability
	player_stats.add_hp_probability += add_hp_probability
	player_stats.add_mp_probability += add_mp_probability
	player_stats.add_coin_probability += add_coin_probability
	player_stats.add_exp_probability += add_exp_probability
	player_stats.add_attack_rate_probability += add_attack_rate_probability
	player_stats.add_range_probability += add_range_probability
	player_stats.add_speed_probability += add_speed_probability
	player_stats.add_armor_probability += add_armor_probability

func minus_to_player(player_stats: PlayerStats):
	player_stats.move_speed -= move_speed
	player_stats.attack_speed -= attack_speed
	player_stats.base_damage -= base_damage
	player_stats.luck -= luck
	player_stats.max_hp -= hp
	player_stats.max_xp -= xp
	player_stats.add_attack_probability -= add_attack_probability
	player_stats.add_hp_probability -= add_hp_probability
	player_stats.add_mp_probability -= add_mp_probability
	player_stats.add_coin_probability -= add_coin_probability
	player_stats.add_exp_probability -= add_exp_probability
	player_stats.add_attack_rate_probability -= add_attack_rate_probability
	player_stats.add_range_probability -= add_range_probability
	player_stats.add_speed_probability -= add_speed_probability
	player_stats.add_armor_probability -= add_armor_probability
	
