class_name Boomerang extends Area2D

@export var fly_speed: float = 180.0
@export var acceleration: float = 20.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var return_back_destory_area: Area2D = $ReturnBackDestoryArea

signal free_signal

var should_turn_back: bool = false

var fly_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(_on_exit_screen)
	return_back_destory_area.body_entered.connect(_on_return_back_body_entered)
	
func start_boomerang_fly(direction: Vector2, pos: Vector2) -> void:
	global_position = pos
	fly_direction = direction
	await get_tree().create_timer(1.0).timeout
	if not return_back_destory_area.monitoring:
		return_back_destory_area.monitoring = true


func _process(delta: float) -> void:
	if should_turn_back:
		var player: Player = get_tree().get_first_node_in_group("Player") as Player
		if player:
			var return_direction: Vector2 = (global_position - player.global_position).normalized()
			global_position = global_position.move_toward(player.global_position, fly_speed * delta)
	else:
		global_position += fly_speed * fly_direction * delta
		

func _on_body_entered(body: Node2D) -> void:
	# 产生撞击特效
	fly_speed = 0.0
	free_signal.emit()
	queue_free()
	
func _on_exit_screen() -> void:
	should_turn_back = true
	if not return_back_destory_area.monitoring:
		return_back_destory_area.monitoring = true

func _on_return_back_body_entered(body: Node2D) -> void:
	free_signal.emit()
	queue_free()
	
