class_name Player extends CharacterBody2D

#region Export
@export var move_speed: float = 60.0;
@export var knockback_force: float = 80.0
#endregion


#region Onready
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_weapon: Node2D = $MainWeapon
@onready var shiled_equipment: Node2D = $ShiledEquipment
@onready var anim_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var hurt_area: Area2D = $HurtArea
@onready var damage_immune_timer: Timer = $DamageImmuneTimer
@onready var health_compoent: HealthComponent = $HealthCompoent as HealthComponent

# Equipment
@onready var shield: Shield = $ShiledEquipment/Shield as Shield
@onready var sword: Sword = $MainWeapon/Sword as Sword
@onready var state_machine: StateMachine = $StateMachine as StateMachine
#endregion

#region signals
signal hurt_signal(damage: Damage)
#endregion

var damage_hold: Damage

var input_direction: Vector2 = Vector2.ZERO
var input_original: Vector2 = Vector2.ZERO
var face_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	animation_tree.active = true
	# 敌人等是body
	hurt_area.body_entered.connect(_on_hurt_body_entered)
	hurt_area.body_exited.connect(_on_hurt_body_exited)
	damage_immune_timer.timeout.connect(_on_damage_immune_timer_timeout)
	init_animtion_params()
	state_machine.init_state_machine()


func _physics_process(delta: float) -> void:
	# 先修改物理相关参数，最后调用move_and_slide进行应用
	state_machine.current_state.physics_update(delta)
	move_and_slide()
	

func _process(delta: float) -> void:
	# 先处理输入等前置条件，然后调用状态机更新逻辑
	hanle_input()
	update_current_face_direction()
	
	state_machine.current_state.logic_update(delta)

func hanle_input() -> void:
	input_original = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	input_direction = input_original.normalized()


func _on_hurt_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var damage_instance: Damage = Damage.new()
		damage_instance.amount = body.damage
		damage_instance.source = body
		damage_hold = damage_instance
		check_damage(damage_hold)

func _on_hurt_body_exited(body: Node2D) -> void:
	damage_hold = null

func check_damage(damage: Damage) -> void:
	# 无敌或者没有删伤害
	if not damage_immune_timer.is_stopped() || damage_hold == null:
		return
	
	health_compoent.take_damge(damage.amount)
	hurt_signal.emit(damage)
	damage_immune_timer.start()


func _on_damage_immune_timer_timeout() -> void:
	check_damage(damage_hold)

func be_hurt() -> void:
	animation_tree["parameters/Hurt/blend_position"] = face_direction
	anim_playback.travel("Hurt")
	var attack_direction: Vector2 = (global_position - damage_hold.source.global_position).normalized()
	velocity = knockback_force * attack_direction
	

func is_dead() -> bool:
	return false

func sword_attack() -> void:
	animation_tree["parameters/Attack/blend_position"] = face_direction
	anim_playback.travel("Attack")
	sword.attack(face_direction)
	shield.attack(face_direction)

func update_animation_params() -> void:
	if input_direction.length() > 0:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/moving"] = true
		animation_tree["parameters/Idle/blend_position"] = input_direction
		animation_tree["parameters/Walk/blend_position"] = input_direction
	else:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/moving"] = false
		
	shield.update_animation_params(self)

func init_body_animation_params() -> void:
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/moving"] = false
	animation_tree["parameters/Idle/blend_position"] = Vector2.DOWN
	animation_tree["parameters/Walk/blend_position"] =  Vector2.ZERO

func init_animtion_params() -> void:
	init_body_animation_params()
	# 盾的动画参数初始化
	shield.init_animtion_params()

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
		
