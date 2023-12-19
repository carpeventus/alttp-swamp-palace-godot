class_name Player extends CharacterBody2D

@export var sword_loading_need_hold_time: float = 0.24
@export var spin_attack_need_charge_time: float = 1.0
#region Onready
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var hurt_area: Area2D = $HurtArea
@onready var damage_immune_timer: Timer = $DamageImmuneTimer
@onready var health_compoent: HealthComponent = $HealthCompoent as HealthComponent

# Equipment
@onready var shield: Shield = $ShiledEquipment/Shield as Shield
@onready var sword: Sword = $MainWeapon/Sword as Sword
@onready var state_machine: StateMachine = $StateMachine as StateMachine
#endregion

var is_dead: bool = false
var forbidden_input: bool = false
var damage_hold: Dictionary = {}
var hurt_blink_tween: Tween

var input_direction: Vector2 = Vector2.ZERO
var face_direction: Vector2 = Vector2.DOWN

var sword_loading_hold_time: float = 0.0
var spin_attack_charge_time: float = 0.0
var is_request_loading: bool = false
var is_spin_attck_ready: bool = false
var can_loading: bool = false

func _ready() -> void:
	animation_tree.active = true
	#region signals
	hurt_area.body_entered.connect(_on_hurt_body_entered) # 敌人等是body
	hurt_area.body_exited.connect(_on_hurt_body_exited)
	health_compoent.died_signal.connect(_on_dead)
	damage_immune_timer.timeout.connect(_on_damage_immune_timer_timeout)
	#endregion
	init_animtion_params()
	state_machine.init_state_machine()


func _physics_process(delta: float) -> void:
	# 先修改物理相关参数，最后调用move_and_slide进行应用
	state_machine.current_state.physics_update(delta)
	move_and_slide()
	
func _process(delta: float) -> void:
	handle_input(delta)
	state_machine.current_state.logic_update(delta)
#endregion

#region hurtdead
func _on_hurt_body_entered(body: Node2D) -> void:
	if body is Enemy:
		var damage_instance: Damage = Damage.new()
		damage_instance.amount = body.damage
		damage_instance.source = body
		damage_hold[body.name] =  damage_instance
		check_take_damage()

func _on_hurt_body_exited(body: Node2D) -> void:
	damage_hold.erase(body.name)

func check_take_damage() -> void:
	# 无敌、无伤害来源或死亡
	if is_dead || not damage_immune_timer.is_stopped() || damage_hold.is_empty():
		return
	
	# 从任意状态转为受伤状态
	state_machine.change_state("PlayerHurtState")
	
func start_immune() -> void:
	damage_immune_timer.start()
	if hurt_blink_tween:
		hurt_blink_tween.kill()
	hurt_blink_tween = create_tween()
	hurt_blink_tween.set_loops()
	hurt_blink_tween.tween_property(self, "modulate:a", 0.2, 0.05).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	hurt_blink_tween.tween_property(self, "modulate:a", 0.8, 0.05).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func _on_damage_immune_timer_timeout() -> void:
	if hurt_blink_tween:
		hurt_blink_tween.kill()
	# 将颜色恢复原样
	modulate = Color.WHITE
	check_take_damage()

func _on_dead() -> void:
	is_dead = true
	
#endregion

#region init
func init_animtion_params() -> void:
	init_body_animation_params()
	# 盾的动画参数初始化
	shield.init_animtion_params()
	
	
func init_body_animation_params() -> void:
	animation_tree["parameters/conditions/idle"] = true
	animation_tree["parameters/conditions/moving"] = false
	animation_tree["parameters/Idle/blend_position"] = Vector2.DOWN
	animation_tree["parameters/Walk/blend_position"] =  Vector2.ZERO
#endregion



#region input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("sword_attack"):
		can_loading = true
	elif event.is_action_released("sword_attack"):
		can_loading = false
		
func handle_input(delta: float) -> void:
	if forbidden_input:
		return
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	# 按下一次攻击后，才可以开始蓄力
	if can_loading and Input.is_action_pressed("sword_attack"):
		sword_loading_hold_time += delta
		if sword_loading_hold_time > sword_loading_need_hold_time:
			is_request_loading = true
		# loading时才能蓄力
		if is_request_loading:
			spin_attack_charge_time += delta
		if spin_attack_charge_time > spin_attack_need_charge_time:
			is_spin_attck_ready = true
	else:
		sword_loading_hold_time = 0.0
		spin_attack_charge_time = 0.0
		is_request_loading = false
		can_loading = false
	#endregion
	

