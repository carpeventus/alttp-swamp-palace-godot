class_name ArrowShootComponent extends Node

@export var positon_offset: Vector2 = Vector2(0, -8)

var arrow_scene: PackedScene = preload("res://props/arrow.tscn") 

func generate_arrow(face_direction: Vector2, pos: Vector2) -> void:
	var spawn_position: Vector2 = pos + positon_offset
	var arrow: Arrow = arrow_scene.instantiate() as Arrow
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(arrow)
	arrow.start_arrow_fly(face_direction, spawn_position)
