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
	
	state_machine.change_state("PlayerIdleState")
	
	
func be_hurt() -> void:
	player.velocity = Vector2.ZERO
	player.animation_tree["parameters/Hurt/blend_position"] = player.face_direction
	player.anim_playback.travel("Hurt")
	# 受伤期间禁止操作
	player.forbidden_input = true
	try_cancel_loading()

	# 选择第一个damage造成伤害，减少hp（godot的字典保持插入时的顺序）
	var damage: Damage = player.damage_hold.values()[0] as Damage
	PlayerGlobal.health_component.take_damge(damage.amount)
	# 如果只能造成一次伤害则立刻删除
	if damage.hit_only_once:
		player.damage_hold.erase(damage.source.name)
	# 被攻击后如果血量大于0，则被击退且无敌
	if PlayerGlobal.health_component.current_health > 0:
		var attack_direction: Vector2 = (player.global_position - damage.source.global_position).normalized()
		if attack_direction == Vector2.ZERO:
			attack_direction = -player.face_direction
		player.velocity = knockback_force * attack_direction
		player.start_immune()

func try_cancel_loading() -> void:
	player.is_spin_attck_ready = false
	player.can_loading = false
	player.is_request_loading = false
	player.sword_loading_hold_time = 0.0
	player.spin_attack_charge_time = 0.0

func on_exit() -> void:
	player.forbidden_input = false
