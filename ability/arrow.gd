class_name Arrow extends Area2D

@export var fly_speed: float = 200.0
@export var fly_time: float = 2.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var fly_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func start_arrow_fly(face_direction: Vector2, pos: Vector2) -> void:
	global_position = pos
	rotation = face_direction.angle()
	fly_direction = face_direction
	await get_tree().create_timer(fly_time).timeout
	queue_free()

func _process(delta: float) -> void:
	global_position += fly_speed * fly_direction * delta

func _on_body_entered(body: Node2D) -> void:
	fly_speed = 0.0
	animation_player.play("hit")
	await animation_player.animation_finished
	queue_free()
