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

func update_moving_position(input_direction: Vector2) -> void:
	if input_direction.length() > 0:
		animation_tree["parameters/ShieldIdle/blend_position"] = input_direction
		animation_tree["parameters/ShieldWalk/blend_position"] = input_direction

func update_moving_conditions(input_direction: Vector2) -> void:
	if input_direction.length() > 0:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/moving"] = true
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false
		

func attack(face_direction: Vector2) -> void:
	animation_tree["parameters/ShieldAttack/blend_position"] = face_direction
	anim_playback.travel("ShieldAttack")


func loading_idle(face_direction: Vector2) -> void:
	# loading之间切换，不更新朝向
	animation_tree["parameters/ShieldLoadingIdle/blend_position"] = face_direction
	animation_tree["parameters/conditions/loading_cancel"] = false
	anim_playback.travel("ShieldLoadingIdle")

func loading_walk(face_direction: Vector2) -> void:
	animation_tree["parameters/ShieldLoadingWalk/blend_position"] = face_direction
	animation_tree["parameters/conditions/loading_cancel"] = false
	anim_playback.travel("ShieldLoadingWalk")

func cancel_loading() -> void:
	animation_tree["parameters/conditions/loading_cancel"] = true
	
