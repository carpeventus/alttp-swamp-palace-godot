class_name SwordEnergy extends Area2D

@export var fly_speed: float = 4.0
@export var fly_time: float = 2.0
@onready var hit_box: HitBox = $HitBox

var fly_direction: Vector2 = Vector2.ZERO
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func start_sowrd_energy_attack(face_direction: Vector2, spawn_position: Vector2) -> void:
	global_position = spawn_position
	fly_direction = face_direction
	await get_tree().create_timer(fly_time).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += fly_speed * fly_direction


func _on_body_entered(body: Node2D) -> void:
	queue_free()
