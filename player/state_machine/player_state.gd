class_name PlayerState extends State

var state_machine: StateMachine

@export var player: Player

func _ready() -> void:
	state_machine = get_parent() as StateMachine
	player.hurt_signal.connect(_on_player_hurt)


func logic_update(delta: float) -> void:
	update_animation_params()
	if player.is_dead():
		state_machine.change_state("PlayerDeadState")

func _on_player_hurt(damage: Damage) -> void:
	state_machine.change_state("PlayerHurtState")


func update_animation_params() -> void:
	if player.input_direction.length() > 0:
		player.animation_tree["parameters/conditions/idle"] = false
		player.animation_tree["parameters/conditions/moving"] = true
		player.animation_tree["parameters/Idle/blend_position"] = player.input_direction
		player.animation_tree["parameters/Walk/blend_position"] = player.input_direction
	else:
		player.animation_tree["parameters/conditions/idle"] = true
		player.animation_tree["parameters/conditions/moving"] = false
		
	player.shield.update_animation(player.input_direction)
