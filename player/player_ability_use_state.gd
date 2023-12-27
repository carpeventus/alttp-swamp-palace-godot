extends PlayerState

@onready var bomb_generator: BombAbilityController = %BombAbilityController

func on_enter() -> void:
	generate_bomb()
	await get_tree().process_frame
	state_machine.change_state("PlayerIdleState")

func generate_bomb() -> void:
	bomb_generator.ability_use(player.face_direction, player.global_position)
