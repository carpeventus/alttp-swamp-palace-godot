class_name Boomerang extends Area2D

@export var fly_speed: float = 180.0
@export var acceleration: float = 20.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hit_effect: HitEffectComponent = $HitEffectComponent

signal free_signal
var is_close_to_player: bool = false
var close_to_player_threshold: float = 4.0

var should_turn_back: bool = false

var fly_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(_on_exit_screen)
	
func start_boomerang_fly(direction: Vector2, pos: Vector2) -> void:
	global_position = pos
	fly_direction = direction


func _process(delta: float) -> void:
	if should_turn_back:
		var player: Player = get_tree().get_first_node_in_group("Player") as Player
		if player:
			global_position = global_position.move_toward(player.global_position, fly_speed * delta)
			if (global_position - player.global_position).length() < close_to_player_threshold:
				destroy_self()
	else:
		global_position += fly_speed * fly_direction * delta
		

func _on_body_entered(body: Node2D) -> void:
	fly_speed = 0.0
	hit_effect.generate_hit_effect(global_position)
	destroy_self()


func _on_exit_screen() -> void:
	should_turn_back = true


func destroy_self() -> void:
	free_signal.emit()
	queue_free()
