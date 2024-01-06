class_name EnemyDeathEffectComponent extends Node

@export var spawn_pos_offset: Vector2 = Vector2.ZERO

var death_effect_scene: PackedScene = preload("res://effects/death_effect.tscn")

func generate_death_effect(pos: Vector2) -> void:
	var spawn_positon: Vector2 = pos + spawn_pos_offset
	var hit_effect: Node2D = death_effect_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(hit_effect)
	hit_effect.global_position = spawn_positon
