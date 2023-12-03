class_name Shield extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree

@onready var anim_playback: AnimationNodeStateMachinePlayback= animation_tree["parameters/playback"]

func _ready() -> void:
	animation_tree.active = true
	init_animtion_params()

func init_animtion_params() -> void:
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/moving"] = false
	animation_tree["parameters/ShieldIdle/blend_position"] = Vector2.DOWN
	animation_tree["parameters/ShieldWalk/blend_position"] =  Vector2.ZERO

func update_animation_params(player: Player) -> void:
	if player.velocity.length() > 0:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/moving"] = true
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false

	if player.input_direction.length() > 0:
		animation_tree["parameters/ShieldIdle/blend_position"] = player.input_direction
		animation_tree["parameters/ShieldWalk/blend_position"] = player.input_direction

func attack(face_direction: Vector2) -> void:
	animation_tree["parameters/ShieldAttack/blend_position"] = face_direction
	anim_playback.travel("ShieldAttack")

