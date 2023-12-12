extends PlayerState

@export var loading_move_speed: float = 60.0

func on_enter() -> void:
	loading_walk()

func on_exit() -> void:
	cancel_loading()
	
func physics_update(delta: float) -> void:
	player.velocity = player.input_direction * loading_move_speed


func logic_update(delta: float) -> void:
	super.logic_update(delta)

	if not player.is_request_loading:
		state_machine.change_state("PlayerWalkState")
	
	if is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerLoadingIdleState")


func loading_walk() -> void:
	player.animation_tree["parameters/LoadingWalk/blend_position"] = player.face_direction
	player.animation_tree["parameters/conditions/loading_cancel"] = false
	player.anim_playback.travel("LoadingWalk")
	
	player.shield.loading_walk(player.face_direction)
	player.sword.loading_walk(player.face_direction)

func cancel_loading() -> void:
	player.animation_tree["parameters/conditions/loading_cancel"] = true
	player.shield.cancel_loading()
	player.sword.cancel_loading()
