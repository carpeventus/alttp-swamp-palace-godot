class_name SwordEnergy extends Area2D

@export var fly_speed: float = 180.0
@export var fly_time: float = 2.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_effect: HitEffectComponent = $HitEffectComponent

var fly_direction: Vector2 = Vector2.ZERO
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func start_sowrd_energy_attack(face_direction: Vector2, spawn_position: Vector2) -> void:
	global_position = spawn_position
	fly_direction = face_direction
	await get_tree().create_timer(fly_time).timeout
	queue_free()

func _process(delta: float) -> void:
	global_position += fly_speed * fly_direction * delta

func _on_body_entered(body: Node2D) -> void:
	fly_speed = 0.0
	hit_effect.generate_hit_effect(global_position)
	queue_free()
