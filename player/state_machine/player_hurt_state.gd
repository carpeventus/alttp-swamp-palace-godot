extends PlayerState

@export var knockback_force: float = 70.0

func on_enter() -> void:
	be_hurt()
	await player.animation_tree.animation_finished
	if state_machine.current_state.name == "PlayerDeadState":
		return
		
	if player.is_dead:
		state_machine.change_state("PlayerDeadState")
		return
		
	if is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerIdleState")
	else:
		state_machine.change_state("PlayerWalkState")
	
	
func be_hurt() -> void:
	player.velocity = Vector2.ZERO
	player.animation_tree["parameters/Hurt/blend_position"] = player.face_direction
	player.anim_playback.travel("Hurt")
	player.forbidden_input = true
	# 选择第一个damage造成伤害，减少hp（godot的字典保持插入时的顺序）
	var damage: Damage = player.damage_hold.values()[0] as Damage
	player.health_compoent.take_damge(damage.amount)
	# 被攻击后如果血量大于0，则被击退且无敌
	if player.health_compoent.current_health > 0:
		var attack_direction: Vector2 = (player.global_position - damage.source.global_position).normalized()
		player.velocity = knockback_force * attack_direction
		player.start_immune()

func on_exit() -> void:
	player.forbidden_input = false
