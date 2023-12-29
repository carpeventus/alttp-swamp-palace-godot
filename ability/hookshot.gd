class_name Hookshot extends Node2D

@export var shoot_duration: float = 0.5
@export var back_duration: float = 0.3
@export var back_offset_distance: float = 16.0

@onready var tip: Area2D = $Tip
@onready var links: Sprite2D = $Links
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $Tip/VisibleOnScreenNotifier2D

var tween_links: Tween
var is_backing: bool = false
var init_position: Vector2
var back_direction_offset_distance: Vector2 = Vector2.ZERO

func _ready() -> void:
	tip.body_entered.connect(_on_body_enterd_tip)
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)

func generate_hookshot(spawn_position: Vector2, face_direction: Vector2, max_length: float) -> void:
	global_position = spawn_position
	rotation = face_direction.angle()
	# 暂存
	init_position = spawn_position
	if face_direction == Vector2.DOWN:
		back_direction_offset_distance = Vector2(0, -back_offset_distance)
	elif face_direction == Vector2.UP:
		back_direction_offset_distance = Vector2(0, back_offset_distance)
	elif face_direction == Vector2.LEFT:
		back_direction_offset_distance = Vector2(back_offset_distance, 0)
	elif face_direction == Vector2.RIGHT:
		back_direction_offset_distance = Vector2(-back_offset_distance, 0)
	
	var target_position: Vector2 = face_direction * max_length + spawn_position
	
	shoot(max_length, target_position, shoot_duration)
	await tween_links.finished
	# 到达最大长度自动收回
	if not is_backing:
		is_backing = true
		take_back(back_duration, init_position)

	
	
func shoot(max_length: float, target_position: Vector2, duration: float) -> void:
	if tween_links:
		tween_links.kill()
	tween_links = create_tween().set_parallel()
	tween_links.tween_property(links, "offset", Vector2(max_length / 2.0, 0), duration)
	tween_links.tween_property(links, "region_rect", Rect2(0, 0, max_length, 8), duration)
	tween_links.tween_property(tip, "global_position", target_position, duration)

func take_back(duration: float, target_position: Vector2) -> void:
	shoot(0, target_position, duration)
	await tween_links.finished
	queue_free()

# 超出屏幕自动收回
func _on_screen_exited() -> void:
	if not is_backing:
		is_backing = true
	take_back(back_duration, init_position)

# 击中时，需要固定tip，同步移动links和player
func _on_body_enterd_tip(body: Node2D) -> void:
	if tween_links:
		tween_links.kill()
	# add a hitstop
	await get_tree().create_timer(0.3).timeout
	if not is_backing:
		is_backing = true
		pull_hookshot_to_tip()
	

func pull_hookshot_to_tip() -> void:
	var player: Node2D = get_tree().get_first_node_in_group("Player") as Node2D
	if not player:
		queue_free()
		return
	var tween_pull: Tween = create_tween().set_parallel()
	var target_pos: Vector2 = tip.global_position + back_direction_offset_distance
	tween_pull.tween_property(links, "offset", Vector2(0.0, 0.0), back_duration)
	tween_pull.tween_property(links, "region_rect", Rect2(0, 0, 0, 8), back_duration)
	tween_pull.tween_property(links, "global_position", target_pos, back_duration)
	tween_pull.tween_property(player, "global_position", target_pos, back_duration)
	await tween_pull.finished
	queue_free()
