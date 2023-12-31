class_name Hookshot extends Node2D

@export var shoot_duration: float = 0.5
@export var back_duration: float = 0.3

@export var player_positon_offset_y: float = 8.0
@export var back_offset_distance: float = 16.0

@onready var tip: Area2D = $Tip
@onready var links: Sprite2D = $Links
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $Tip/VisibleOnScreenNotifier2D
@onready var hit_effect: HitEffectComponent = $Tip/HitEffectComponent


signal free_signal

var tween_links: Tween
var shoot_direction: Vector2
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
	shoot_direction = face_direction

	var target_position: Vector2 = shoot_direction * max_length + spawn_position
	
	shoot(max_length, target_position, shoot_duration)
	await tween_links.finished
	# 到达最大长度自动收回
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
	destory_self()

# 超出屏幕自动收回
func _on_screen_exited() -> void:
	take_back(back_duration, init_position)

# 击中时，需要固定tip，同步移动links和player
func _on_body_enterd_tip(body: Node2D) -> void:
	if not body is HookAble:
		hit_effect.generate_hit_effect(tip.global_position)
		take_back(back_duration, init_position)
	else:
		if tween_links:
			tween_links.kill()
		if not visible_on_screen_notifier.is_on_screen():
			take_back(back_duration, init_position)
		else:
			# add a hitstop
			await get_tree().create_timer(0.3).timeout
			pull_hookshot_to_tip()


func pull_hookshot_to_tip() -> void:
	var player: Node2D = get_tree().get_first_node_in_group("Player") as Node2D
	if not player:
		destory_self()
		return
		
	if shoot_direction == Vector2.DOWN:
		back_direction_offset_distance = Vector2(0, 0)
	elif shoot_direction == Vector2.UP:
		back_direction_offset_distance = Vector2(0, back_offset_distance)
	elif shoot_direction == Vector2.LEFT:
		back_direction_offset_distance = Vector2(back_offset_distance / 2, 0)
	elif shoot_direction == Vector2.RIGHT:
		back_direction_offset_distance = Vector2(-back_offset_distance / 2, 0)
	
	var target_pos: Vector2 = tip.global_position + back_direction_offset_distance
	print("hook will to pos %s" %target_pos)
	var target_player_pos: Vector2 = target_pos
	if shoot_direction == Vector2.LEFT || shoot_direction == Vector2.RIGHT:
		target_player_pos = target_pos + Vector2(0, player_positon_offset_y)
	
	print("player will to pos %s" %target_player_pos)
	var tween_pull: Tween = create_tween().set_parallel()

	tween_pull.tween_property(links, "offset", Vector2(0.0, 0.0), back_duration)
	tween_pull.tween_property(links, "region_rect", Rect2(0, 0, 0, 8), back_duration)
	tween_pull.tween_property(links, "global_position", target_pos, back_duration)
	tween_pull.tween_property(player, "global_position", target_player_pos, back_duration)
	await tween_pull.finished
	destory_self()
	
func destory_self() -> void:
	free_signal.emit()
	queue_free()
