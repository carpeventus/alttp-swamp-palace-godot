class_name VelocityComponent extends Node

@export var max_speed: float = 20.0
@export var acceleration: float = 20.0

var body_velocity: Vector2 = Vector2.ZERO

func accelerate_in_direction(direction: Vector2) -> void:
	var targetVelocity: Vector2 = max_speed * direction
	body_velocity = body_velocity.lerp(targetVelocity, (1 - exp(-acceleration * get_process_delta_time() * 20)))
	
func move(body: CharacterBody2D) -> void:
	body.velocity = body_velocity
	body.move_and_slide()
	body_velocity = body.velocity
	
func accelerate_to_player() -> void:
	if owner is Node2D:
		var player: Node2D = get_tree().get_first_node_in_group("Player") as Node2D
		var direction: Vector2 =  (player.global_position - owner.global_position).normalized()
		accelerate_in_direction(direction)

