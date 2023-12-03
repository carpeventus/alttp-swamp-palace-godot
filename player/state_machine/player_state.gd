class_name PlayerState extends State

var state_machine: StateMachine

@export var player: Player

func _ready() -> void:
	state_machine = get_parent() as StateMachine
	player.hurt_signal.connect(_on_player_hurt)


func logic_update(delta: float) -> void:
	player.update_animation_params()
	if player.is_dead():
		state_machine.change_state("PlayerDeadState")

func _on_player_hurt(damage: Damage) -> void:
	state_machine.change_state("PlayerHurtState")
