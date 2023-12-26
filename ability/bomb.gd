class_name Bomb extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func place_bomb(spawn_position: Vector2) -> void:
	global_position = spawn_position
	animation_player.play("idle")
	await animation_player.animation_finished
	animation_player.play("alert")
	await get_tree().create_timer(1.0).timeout
	animation_player.play("explosion")
