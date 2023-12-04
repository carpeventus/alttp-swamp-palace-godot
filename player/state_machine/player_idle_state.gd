extends PlayerState

func logic_update(delta: float) -> void:
	super.logic_update(delta)
	
	if Input.is_action_just_pressed("sword_attack"):
		state_machine.change_state("PlayerAttackState")
	
	if not is_zero_approx(player.input_direction.length()):
		state_machine.change_state("PlayerWalkState")

func on_enter() -> void:
	player.velocity = Vector2.ZERO
	


