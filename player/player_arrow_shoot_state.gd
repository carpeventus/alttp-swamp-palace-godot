extends PlayerState

@onready var arrow_shooter: ArrowShootComponent = %ArrowShootComponent

func on_enter() -> void:
	shoot()
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return
	
	state_machine.change_state("PlayerIdleState")

func shoot() -> void:
	player.velocity = Vector2.ZERO
	arrow_shooter.generate_arrow(player.face_direction, player.global_position)
	player.animation_tree["parameters/ArrowShoot/blend_position"] = player.face_direction
	player.anim_playback.travel("ArrowShoot")
	

