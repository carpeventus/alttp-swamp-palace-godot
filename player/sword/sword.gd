class_name Sword extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_playback: AnimationNodeStateMachinePlayback= animation_tree["parameters/playback"]

func _ready() -> void:
	animation_tree.active = true

func attack(direction: Vector2) -> void:
	animation_tree["parameters/SwordAttack/blend_position"] = direction
	anim_playback.travel("SwordAttack")
	
