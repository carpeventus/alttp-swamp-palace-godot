class_name Sword extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_playback: AnimationNodeStateMachinePlayback= animation_tree["parameters/playback"]

func _ready() -> void:
	animation_tree.active = true

func attack(direction: Vector2) -> void:
	animation_tree["parameters/SwordAttack/blend_position"] = direction
	anim_playback.travel("SwordAttack")

func spin_attack(direction: Vector2) -> void:
	animation_tree["parameters/SwordSpinAttack/blend_position"] = direction
	anim_playback.travel("SwordSpinAttack")

func loading_idle(face_direction: Vector2) -> void:
	animation_tree["parameters/SwordLoadingIdle/blend_position"] = face_direction
	animation_tree["parameters/conditions/loading_cancel"] = false
	anim_playback.travel("SwordLoadingIdle")

func loading_walk(face_direction: Vector2) -> void:
	animation_tree["parameters/SwordLoadingWalk/blend_position"] = face_direction
	animation_tree["parameters/conditions/loading_cancel"] = false
	anim_playback.travel("SwordLoadingWalk")

func cancel_loading() -> void:
	animation_tree["parameters/conditions/loading_cancel"] = true
	
