class_name BombAbilityController extends AbilityController

var bomb_scene: PackedScene = preload("res://ability/bomb.tscn") 
@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer

func ability_use(face_direction: Vector2, pos: Vector2) -> void:
	if not spawn_interval_timer.is_stopped():
		return
	spawn_interval_timer.start()
	var spawn_position: Vector2 = pos
	var bomb: Bomb = bomb_scene.instantiate() as Bomb
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(bomb)
	bomb.place_bomb(spawn_position)
