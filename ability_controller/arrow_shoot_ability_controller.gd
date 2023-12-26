class_name ArrowShootAbilityController extends AbilityController

@export var positon_offset: Vector2 = Vector2(0, -8)
@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer

var arrow_scene: PackedScene = preload("res://ability/arrow.tscn") 

func ability_use(face_direction: Vector2, pos: Vector2) -> void:
	if not spawn_interval_timer.is_stopped():
		return
	spawn_interval_timer.start()
	var spawn_position: Vector2 = pos + positon_offset
	var arrow: Arrow = arrow_scene.instantiate() as Arrow
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(arrow)
	arrow.start_arrow_fly(face_direction, spawn_position)
