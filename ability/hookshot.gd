class_name Hookshot extends Node2D

@onready var tip: Area2D = $Tip
@onready var links: Sprite2D = $Links
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $Tip/VisibleOnScreenNotifier2D

signal hooked_signal(hooked_position: Vector2)

var tween_links: Tween
var reversing: bool = false
var init_position: Vector2
var back_duration: float

func _ready() -> void:
	tip.body_entered.connect(_on_body_enterd_tip)
	visible_on_screen_notifier.screen_exited.connect(_on_screen_exited)

func generate_hookshot(spawn_position: Vector2, direction: Vector2, max_length: float, duration: float, reverse_duration: float) -> void:
	global_position = spawn_position
	rotation = direction.normalized().angle()
	# 暂存
	init_position = spawn_position
	back_duration = reverse_duration
	var target_position: Vector2 = direction * max_length + spawn_position
	
	shoot(max_length, target_position, duration)
	await tween_links.finished
	if not reversing:
		reversing = true
		reverse_shoot(back_duration, init_position)

	
	
func shoot(max_length: float, target_position: Vector2, duration: float) -> void:
	if tween_links:
		tween_links.kill()
	tween_links = create_tween().set_parallel()
	tween_links.tween_property(links, "offset", Vector2(max_length / 2.0, 0), duration)
	tween_links.tween_property(links, "region_rect", Rect2(0, 0, max_length, 8), duration)
	tween_links.tween_property(tip, "global_position", target_position, duration)

func reverse_shoot(duration: float, target_position: Vector2) -> void:
	shoot(0, target_position, duration)
	await tween_links.finished
	queue_free()
	
func _on_screen_exited() -> void:
	if not reversing:
		reversing = true
	reverse_shoot(back_duration, init_position)

func _on_body_enterd_tip(body: Node2D) -> void:
	if tween_links:
		tween_links.kill()
	await get_tree().create_timer(0.2).timeout
	if not reversing:
		reversing = true
	reverse_shoot(back_duration, init_position)
	hooked_signal.emit(tip.global_position)
	

