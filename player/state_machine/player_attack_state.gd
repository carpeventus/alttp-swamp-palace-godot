extends PlayerState


func on_enter() -> void:
	sword_attack()
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return
	
	state_machine.change_state("PlayerIdleState")

func sword_attack() -> void:
	player.velocity = Vector2.ZERO
	player.animation_tree["parameters/Attack/blend_position"] = player.face_direction
	player.anim_playback.travel("Attack")
	player.sword.attack(player.face_direction)
	player.shield.attack(player.face_direction)


