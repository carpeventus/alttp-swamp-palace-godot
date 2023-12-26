extends PlayerState

@onready var bomb_generator: BombAbilityController = %BombAbilityController

func on_enter() -> void:
	shoot()
	if state_machine.current_state.name == "PlayerDeadState":
		return
	#await get_tree().create_timer(0.5).timeout
	state_machine.change_state("PlayerIdleState")

func on_exit() -> void:
	print("exit use")

func shoot() -> void:
	bomb_generator.ability_use(player.face_direction, player.global_position)
