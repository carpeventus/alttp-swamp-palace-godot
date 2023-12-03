extends PlayerState

func on_enter() -> void:
	player.velocity = Vector2.ZERO
	player.be_hurt()
	## TODO 击退效果
	await player.animation_tree.animation_finished
	
	if is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerIdleState")
	else:
		state_machine.change_state("PlayerWalkState")
	
	
	
