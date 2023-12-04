extends PlayerState

@export var knockback_force: float = 80.0

func on_enter() -> void:
	player.velocity = Vector2.ZERO
	be_hurt()
	await player.animation_tree.animation_finished
	
	if is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerIdleState")
	else:
		state_machine.change_state("PlayerWalkState")
	
	
func be_hurt() -> void:
	player.animation_tree["parameters/Hurt/blend_position"] = player.face_direction
	player.anim_playback.travel("Hurt")
	var attack_direction: Vector2 = (player.global_position - player.damage_hold.source.global_position).normalized()
	player.velocity = knockback_force * attack_direction
