extends PlayerState

var should_cancel_loading: bool

func logic_update(delta: float) -> void:
	super.logic_update(delta)

	# 回旋斩准备就绪且松开攻击按键
	if Input.is_action_just_released("sword_attack") and player.is_spin_attck_ready:
		state_machine.change_state("PlayerSpinAttackState")
	elif not player.is_request_loading:
		state_machine.change_state("PlayerIdleState")
	elif player.sword.is_hit_enmey:
		state_machine.change_state("PlayerTapingEnemyState")
	elif not is_zero_approx(player.input_direction.length()):
		should_cancel_loading = false
		state_machine.change_state("PlayerLoadingWalkState")


func on_enter() -> void:
	should_cancel_loading = true
	player.velocity = Vector2.ZERO
	loading_idle()

func on_exit() -> void:
	cancel_loading()

func loading_idle() -> void:
	# loading之间切换，不更新朝向
	player.animation_tree["parameters/LoadingIdle/blend_position"] = player.face_direction
	player.animation_tree["parameters/conditions/loading_cancel"] = false
	player.anim_playback.travel("LoadingIdle")
	
	player.shield.loading_idle(player.face_direction)
	player.sword.loading_idle(player.face_direction)

func cancel_loading() -> void:
	if not should_cancel_loading:
		return
	player.is_spin_attck_ready = false
	player.is_request_loading = false
	player.sword_loading_hold_time = 0.0
	player.spin_attack_charge_time = 0.0
	player.animation_tree["parameters/conditions/loading_cancel"] = true
	player.shield.cancel_loading()
	player.sword.cancel_loading()
