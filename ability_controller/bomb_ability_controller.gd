class_name BombAbilityController extends AbilityController

@export var spwan_offset:float = 16.0

var bomb_scene: PackedScene = preload("res://ability/bomb.tscn") 
@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer

func ability_use(face_direction: Vector2, pos: Vector2) -> void:
	if not spawn_interval_timer.is_stopped():
		return
	
	var offset: Vector2 = Vector2.ZERO
	if face_direction == Vector2.DOWN:
		offset = Vector2(0, spwan_offset)
	elif face_direction == Vector2.UP:
		offset = Vector2(0, -spwan_offset)
	elif face_direction == Vector2.LEFT:
		offset = Vector2(-spwan_offset, 0)
	elif face_direction == Vector2.RIGHT:
		offset = Vector2(spwan_offset, 0)
	spawn_interval_timer.start()
	var spawn_position: Vector2 = pos + offset
	var bomb: Bomb = bomb_scene.instantiate() as Bomb
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(bomb)
	bomb.place_bomb(spawn_position)
