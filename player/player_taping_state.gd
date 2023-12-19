extends PlayerState

func on_enter() -> void:
	taping()
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return
	state_machine.change_state("PlayerIdleState")


func taping() -> void:
	player.velocity = Vector2.ZERO
	player.can_loading = false
	player.animation_tree["parameters/TapingEnemy/blend_position"] = player.face_direction
	player.anim_playback.travel("TapingEnemy")
	player.sword.taping(player.face_direction)
