class_name SwordEnergy extends CharacterBody2D

@export var fly_speed: float = 200.0
@export var fly_time: float = 2.0
@onready var hit_box: HitBox = $HitBox

var fly_direction: Vector2 = Vector2.ZERO

func start_sowrd_energy_attack(face_direction: Vector2) -> void:
	fly_direction = face_direction
	await get_tree().create_timer(fly_time).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity = fly_speed * fly_direction;
	var is_collosion: bool = move_and_slide()
	if is_collosion:
		queue_free()

