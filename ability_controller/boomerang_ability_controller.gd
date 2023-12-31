class_name BoomerangAbilityController extends AbilityController

var boomerang_scene: PackedScene = preload("res://ability/boomerang.tscn") 
var can_generate: bool = true

func ability_use(direction: Vector2, pos: Vector2) -> void:
	if not can_generate:
		return
	var spawn_position: Vector2 = pos
	var boomerang: Boomerang = boomerang_scene.instantiate() as Boomerang
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(boomerang)
	boomerang.free_signal.connect(_on_boomerang_free)
	can_generate = false
	boomerang.start_boomerang_fly(direction, spawn_position)
	

func _on_boomerang_free() -> void:
	can_generate = true
