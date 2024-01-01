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
## TODO test
var hookshot_ability: AbilityResource = preload("res://resources/hookshot.tres")
#endregion

var ability_dict: Dictionary = {}
var current_selected_ability_id: String

func init_abilities() -> void:
	add_ability(arrow_ability)
	add_ability(bomb_ability)
	add_ability(boomerang_ability)
	## TODO test
	add_ability(hookshot_ability)
	# default selected bow and arrow
	select_ability(boomerang_ability.id)

func select_ability(ability_id: String) -> void:
	current_selected_ability_id = ability_id
	
func add_ability(ability_resource: AbilityResource) -> void:
	ability_dict[ability_resource.id] = ability_resource.related_state

func get_current_ability_state() -> String:
	return ability_dict[current_selected_ability_id]

func _ready() -> void:
	health_component.died_signal.connect(_on_player_died)
	init_abilities()

func _on_player_died() -> void:
	player_died_signal.emit()
