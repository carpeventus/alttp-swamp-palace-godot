extends PlayerState

func on_enter() -> void:
	taping_enemy()
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return
	state_machine.change_state("PlayerIdleState")


func taping_enemy() -> void:
	player.velocity = Vector2.ZERO
	player.animation_tree["parameters/TapingWall/blend_position"] = player.face_direction
	player.anim_playback.travel("TapingWall")
	player.sword.taping_enemy(player.face_direction)
	player.shield.taping_enemy(player.face_direction)
