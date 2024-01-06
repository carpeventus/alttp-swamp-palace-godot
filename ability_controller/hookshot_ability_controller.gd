class_name HookshotAbilityController extends AbilityController

@export var max_lengh: float = 192.0
@export var positon_offset_y: float = -8.0
@export var positon_offset_x: float = 12.0

var hookshot_scene: PackedScene = preload("res://ability/hookshot.tscn") 
var can_generate: bool = true

signal hookshot_used_signal

func ability_use(face_direction: Vector2, pos: Vector2) -> void:
	if not can_generate:
		return
	var offset: Vector2 = Vector2.ZERO
	if face_direction == Vector2.DOWN:
		offset = Vector2(0, 0)
	elif face_direction == Vector2.UP:
		offset = Vector2(0, 2 * positon_offset_y)
	elif face_direction == Vector2.LEFT:
		offset = Vector2(-positon_offset_x, positon_offset_y)
	elif face_direction == Vector2.RIGHT:
		offset = Vector2(positon_offset_x, positon_offset_y)
	var spawn_position: Vector2 = pos + offset
	var hook: Hookshot = hookshot_scene.instantiate() as Hookshot
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(hook)
	hook.free_signal.connect(_on_hookshot_free)
	can_generate = false
	hook.generate_hookshot(spawn_position, face_direction, max_lengh)


func _on_hookshot_free() -> void:
	can_generate = true
	hookshot_used_signal.emit()
