class_name PlayerState extends State

var state_machine: StateMachine

var player: Player

func _ready() -> void:
	state_machine = get_parent() as StateMachine
	player = get_tree().get_first_node_in_group("Player") as Player

func logic_update(delta: float) -> void:
	# loading状态下不能改变朝向
	if state_machine.current_state.name == "PlayerLoadingIdleState" or state_machine.current_state.name == "PlayerLoadingWalkState":
		update_moving_conditions()
	else:
		update_current_face_direction()
		update_moving_positons()
		update_moving_conditions()
	# 死亡且当前不是死亡状态，切换到死亡状态;受伤状态中先不立即切换到死亡
	if player.is_dead and state_machine.current_state.name != "PlayerDeadState" and state_machine.current_state.name != "PlayerHurtState":
		state_machine.change_state("PlayerDeadState")
	

func update_moving_positons() -> void:
	if player.input_direction.length() > 0:
		player.animation_tree["parameters/Idle/blend_position"] = player.input_direction
		player.animation_tree["parameters/Walk/blend_position"] = player.input_direction
		
	player.shield.update_moving_position(player.input_direction)


func update_moving_conditions() -> void:
	if player.input_direction.length() > 0:
		player.animation_tree["parameters/conditions/idle"] = false
		player.animation_tree["parameters/conditions/moving"] = true
	else:
		player.animation_tree["parameters/conditions/idle"] = true
		player.animation_tree["parameters/conditions/moving"] = false
		
	player.shield.update_moving_conditions(player.input_direction)


func update_current_face_direction() -> void:
	if is_zero_approx(player.input_direction.length()):
		return
	# 先判定左右，我们规定当同时按上和右时，最终呈现朝右的动画；总之，同时按下多个方向时，左右优先于上下的动画
	if player.input_direction.x > 0:
		player.face_direction = Vector2.RIGHT
	elif player.input_direction.x < 0:
		player.face_direction = Vector2.LEFT
	elif player.input_direction.y > 0:
		player.face_direction = Vector2.DOWN
	elif player.input_direction.y < 0:
		player.face_direction = Vector2.UP
		
