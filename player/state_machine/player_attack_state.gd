extends PlayerState


func on_enter() -> void:
	player.velocity = Vector2.ZERO
	sword_attack()
	await player.animation_tree.animation_finished
	if is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerIdleState")
	else:
		state_machine.change_state("PlayerWalkState")

func sword_attack() -> void:
	player.animation_tree["parameters/Attack/blend_position"] = player.face_direction
	player.anim_playback.travel("Attack")
	player.sword.attack(player.face_direction)
	player.shield.attack(player.face_direction)
