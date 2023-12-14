extends PlayerState

func on_enter() -> void:
	spin_attack()
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return

	if is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerIdleState")
	else:
		state_machine.change_state("PlayerWalkState")


func spin_attack() -> void:
	player.velocity = Vector2.ZERO
	player.is_spin_attck_ready = false
	player.is_request_loading = false
	player.animation_tree["parameters/SpinAttack/blend_position"] = player.face_direction
	player.anim_playback.travel("SpinAttack")
	player.sword.spin_attack(player.face_direction)
	player.shield.spin_attack(player.face_direction)
