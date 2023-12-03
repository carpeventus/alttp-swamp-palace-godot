class_name Player extends CharacterBody2D

#region Export
@export var move_speed: float = 60.0;
#endregion

#region Onready
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_weapon: Node2D = $MainWeapon
@onready var shiled_equipment: Node2D = $ShiledEquipment
@onready var anim_playback: AnimationNodeStateMachinePlayback= animation_tree["parameters/playback"]
# Equipment
@onready var shield: Shield = $ShiledEquipment/Shield
@onready var sword: Sword = $MainWeapon/Sword
#endregion


var input_direction: Vector2 = Vector2.ZERO
var input_original: Vector2 = Vector2.ZERO
var face_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	animation_tree.active = true
	set_wapon()
	init_animtion_params()


func _physics_process(delta: float) -> void:
	velocity = input_direction * move_speed
	move_and_slide()

func _process(delta: float) -> void:
	input_original = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	input_direction = input_original.normalized()
	update_current_face_direction()
	update_animation_params()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("sword_attack"):
		animation_tree["parameters/Attack/blend_position"] = face_direction
		anim_playback.travel("Attack")
		
		sword.attack(face_direction)
		shield.attack(face_direction)


func init_animtion_params() -> void:
	init_body_animation_params()
	# 盾的动画参数初始化
	shield.init_animtion_params()


func init_body_animation_params() -> void:
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/moving"] = false
	animation_tree["parameters/Idle/blend_position"] = Vector2.DOWN
	animation_tree["parameters/Walk/blend_position"] =  Vector2.ZERO

func update_animation_params() -> void:
	update_body_animation_params()
	shield.update_animation_params(self)


func update_body_animation_params() -> void:
	if velocity.length() > 0:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/moving"] = true
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false

	if input_direction.length() > 0:
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction


func update_current_face_direction() -> void:
		if is_zero_approx(input_direction.length()):
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
			




#region TODO 如果想通过拾取的方式获得武器可以使用，因为是Demo就让玩家自带剑盾了
func set_wapon() -> void:
	pass
	# set_main_weapon(sword_scene)
	# set_shield(red_shield_scene)

func set_main_weapon(weapon: PackedScene) -> void:
	var sword_weapon: Sword = weapon.instantiate() as Sword
	main_weapon.add_child(sword_weapon)
	sword = sword_weapon

func set_shield(shied_scene: PackedScene) -> void:
	var shield_instannce: Shield = shied_scene.instantiate() as Shield
	shiled_equipment.add_child(shield_instannce)
	shield = shield_instannce
#endregion
