extends Node

@onready var health_component: HealthComponent = $HealthComponent as HealthComponent

signal player_died_signal

#region money and ammo
var ruby_amount: int = 0
var bomb_amount: int = 0
var arrow_amount: int = 0
#endregion

#region ability resources
var arrow_ability: AbilityResource = preload("res://resources/arrow.tres")
var bomb_ability: AbilityResource = preload("res://resources/bomb.tres")
var boomerang_ability: AbilityResource = preload("res://resources/boomerang.tres")
#endregion

var ability_dict: Dictionary = {}
var current_selected_ability_name: String

func init_abilities() -> void:
	ability_dict[arrow_ability.id] = "PlayerArrowShootState"
	ability_dict[bomb_ability.id] = "PlayerBombUseState"
	ability_dict[boomerang_ability.id] = "PlayerBoomerangUseState"
	# default selected bow and arrow
	current_selected_ability_name = arrow_ability.id
	
func add_ability(ability_name: String, state_name: String) -> void:
	ability_dict[ability_name] = state_name

func get_current_ability_state() -> String:
	return ability_dict[current_selected_ability_name]

func _ready() -> void:
	health_component.died_signal.connect(_on_player_died)
	init_abilities()

func _on_player_died() -> void:
	player_died_signal.emit()
