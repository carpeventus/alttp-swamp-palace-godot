class_name Enemy extends CharacterBody2D

@export var damage: int = 1
@export var knockback_force: float = 200.0

@onready var health_compoent: HealthComponent = $HealthComponent as HealthComponent
@onready var hurt_box: HurtBox = $HurtBox
@onready var velocity_component: VelocityComponent = $VelocityComponent

var is_hurt: bool = false
var is_dead: bool = false

signal died_signal

func _ready() -> void:
	died_signal.connect(_on_die)
	hurt_box.hurt_signal.connect(_on_hurt)

func _on_die() -> void:
	destory_self()

func _physics_process(delta: float) -> void:
	# 没受伤则移动
	if not is_hurt:
		move()
	velocity_component.move(self)

func destory_self() -> void:
	pass

func move() -> void:
	pass
	
func _on_hurt(damage_source: Damage) -> void:
	is_hurt = true
	## todo stun
	if damage_source.make_stun:
		pass
	var attack_direction: Vector2 = (global_position - damage_source.source.global_position).normalized()
	if attack_direction == Vector2.ZERO:
		attack_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		
	velocity_component.body_velocity = knockback_force * attack_direction
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(velocity_component, "body_velocity", Vector2.ZERO, 0.3)
	await tween.finished
	is_hurt = false
	if health_compoent.current_health <= 0 and not is_dead:
		died_signal.emit()
	

