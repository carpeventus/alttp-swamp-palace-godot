extends PlayerState

@onready var boomerang_shooter: BoomerangAbilityController = %BoomerangAbilityController

func on_enter() -> void:
	if boomerang_shooter.can_generate:
		shoot()
	else:
		await get_tree().process_frame
		if state_machine.current_state.name == "PlayerDeadState":
			return
		state_machine.change_state("PlayerIdleState")

	


func shoot() -> void:
	player.velocity = Vector2.ZERO
	var direction: Vector2 = player.face_direction
	if player.input_direction.length() > 0:
		direction = player.input_direction
	boomerang_shooter.ability_use(direction, player.global_position)
	player.animation_tree["parameters/Boomerang/blend_position"] = player.face_direction
	player.anim_playback.travel("Boomerang")
	player.shield.boomerang(player.face_direction)
	
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return
	
	state_machine.change_state("PlayerIdleState")
