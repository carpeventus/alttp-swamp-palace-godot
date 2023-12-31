extends PlayerState

@onready var hook_shot_controller: HookshotAbilityController = %HookshotAbilityController

func _ready() -> void:
	super._ready()
	hook_shot_controller.hookshot_used_signal.connect(_on_hookshot_used)

func on_enter() -> void:
	if hook_shot_controller.can_generate:
		hookshoot()
	else:
		await get_tree().process_frame
		if state_machine.current_state.name == "PlayerDeadState":
			return
		state_machine.change_state("PlayerIdleState")

func hookshoot() -> void:
	player.velocity = Vector2.ZERO
	hook_shot_controller.ability_use(player.face_direction, player.global_position)
	player.animation_tree["parameters/conditions/hookshot_used"] = false
	player.animation_tree["parameters/Hookshot/blend_position"] = player.face_direction
	player.anim_playback.travel("Hookshot")
	player.shield.hookshot(player.face_direction)

func _on_hookshot_used() -> void:
	player.animation_tree["parameters/conditions/hookshot_used"] = true
	player.shield.hookshot_used_done()
	if state_machine.current_state.name == "PlayerDeadState":
		return
	state_machine.change_state("PlayerIdleState")
