extends CharacterBody2D

#region export
@export var move_speed: float = 60.0;
#endregion

#region onready
@onready var animation_tree: AnimationTree = $AnimationTree
#endregion


var input_direction: Vector2 = Vector2.ZERO
var input_original: Vector2 = Vector2.ZERO
var face_direction: Vector2 = Vector2.DOWN


func _physics_process(delta: float) -> void:
	velocity = input_direction * move_speed
	move_and_slide()


func _ready() -> void:
	animation_tree.active = true
	init_animtion_params()

func _process(delta: float) -> void:
	input_original = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	input_direction = input_original.normalized()
	update_current_face_direction()
	update_animation_params()


func init_animtion_params() -> void:
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/moving"] = false
	animation_tree["parameters/Idle/blend_position"] = Vector2.DOWN
	animation_tree["parameters/Walk/blend_position"] =  Vector2.ZERO


func update_animation_params() -> void:
	if velocity.length() > 0:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/moving"] = true
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false

	if input_direction != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
		


func update_current_face_direction() -> void:
		if input_direction == Vector2.ZERO:
			return
		# 先判定左右，我们规定当同时按上和右时，最终呈现朝右的动画；总之，同时按下多个方向时，左右优先于上下的动画
		if input_direction.x > 0:
			face_direction = Vector2.RIGHT
		elif input_direction.x < 0:
			face_direction = Vector2.LEFT
		elif input_direction.y > 0:
			face_direction = Vector2.DOWN
		elif input_direction.y < 0:
			face_direction = Vector2.UP
