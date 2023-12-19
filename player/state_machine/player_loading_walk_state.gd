extends PlayerState

@export var loading_move_speed: float = 60.0

var should_cancel_loading: bool

func on_enter() -> void:
	should_cancel_loading = true
	loading_walk()

func on_exit() -> void:
	cancel_loading()

func physics_update(delta: float) -> void:
	player.velocity = player.input_direction * loading_move_speed


func logic_update(delta: float) -> void:
	super.logic_update(delta)
	# 回旋斩准备就绪且松开攻击按键
	if Input.is_action_just_released("sword_attack") and player.is_spin_attck_ready:
		state_machine.change_state("PlayerSpinAttackState")
	elif not player.is_request_loading:
		state_machine.change_state("PlayerIdleState")
	elif player.sword.is_hit_enmey:
		state_machine.change_state("PlayerTapingEnemyState")
	elif is_zero_approx(player.input_direction.length()):
		should_cancel_loading = false
		state_machine.change_state("PlayerLoadingIdleState")


func loading_walk() -> void:
	player.animation_tree["parameters/LoadingWalk/blend_position"] = player.face_direction
	player.animation_tree["parameters/conditions/loading_cancel"] = false
	player.anim_playback.travel("LoadingWalk")
	
	player.shield.loading_walk(player.face_direction)
	player.sword.loading_walk(player.face_direction)

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
