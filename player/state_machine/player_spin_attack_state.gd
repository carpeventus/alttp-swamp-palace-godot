extends PlayerState

func on_enter() -> void:
	spin_attack()
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return
	state_machine.change_state("PlayerIdleState")


func spin_attack() -> void:
	player.velocity = Vector2.ZERO
	player.animation_tree["parameters/SpinAttack/blend_position"] = player.face_direction
	player.anim_playback.travel("SpinAttack")
	player.sword.spin_attack(player.face_direction)
	
