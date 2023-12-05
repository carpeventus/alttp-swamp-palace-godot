class_name PlayerState extends State

var state_machine: StateMachine

@export var player: Player

func _ready() -> void:
	state_machine = get_parent() as StateMachine


func logic_update(delta: float) -> void:
	update_animation_params()
	# 死亡且当前不是死亡状态，切换到死亡状态;受伤状态中先不立即切换到死亡
	if player.is_dead and state_machine.current_state.name != "PlayerDeadState" and state_machine.current_state.name != "PlayerHurtState":
		state_machine.change_state("PlayerDeadState")
	

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
