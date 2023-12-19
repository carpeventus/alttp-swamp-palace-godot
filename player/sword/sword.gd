class_name Sword extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var hit_box: HitBox = $HitBox

var is_hit_body: bool = false
var base_damage: int

func _ready() -> void:
	animation_tree.active = true
	base_damage = hit_box.damage
	hit_box.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	is_hit_body = true
	
func _on_body_exit(body: Node2D) -> void:
	is_hit_body = false

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
	
func increase_hit_damage() -> void:
	hit_box.damage = base_damage * 2
	hit_box.monitorable = true


func restore_hit_damage() -> void:
	hit_box.damage = base_damage
