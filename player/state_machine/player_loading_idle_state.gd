extends PlayerState

func logic_update(delta: float) -> void:
	super.logic_update(delta)

	# 回旋斩准备就绪且松开攻击按键
	if Input.is_action_just_released("sword_attack") and player.is_spin_attck_ready:
		state_machine.change_state("PlayerSpinAttackState")

	if not player.is_request_loading:
		print("turn idle")
		cancel_loading()
		state_machine.change_state("PlayerIdleState")
	
	if not is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerLoadingWalkState")

func on_enter() -> void:
	print("enter loading idle")
	player.velocity = Vector2.ZERO
	loading_idle()

func loading_idle() -> void:
	# loading之间切换，不更新朝向
	player.animation_tree["parameters/LoadingIdle/blend_position"] = player.face_direction
	player.animation_tree["parameters/conditions/loading_cancel"] = false
	player.anim_playback.travel("LoadingIdle")
	
	player.shield.loading_idle(player.face_direction)
	player.sword.loading_idle(player.face_direction)

func cancel_loading() -> void:
	player.animation_tree["parameters/conditions/loading_cancel"] = true
	player.shield.cancel_loading()
	player.sword.cancel_loading()
