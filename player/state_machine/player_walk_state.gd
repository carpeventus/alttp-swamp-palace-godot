extends PlayerState

@export var move_speed: float = 60.0

func logic_update(delta: float) -> void:
	super.logic_update(delta)
	
	if Input.is_action_just_pressed("sword_attack"):
		state_machine.change_state("PlayerAttackState")
	elif Input.is_action_just_pressed("item_use"):
		state_machine.change_state(PlayerGlobal.get_current_ability_state())
	elif player.is_request_loading:
		state_machine.change_state("PlayerLoadingWalkState")
	elif is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerIdleState")


func physics_update(delta: float) -> void:
	player.velocity = player.input_direction * move_speed

