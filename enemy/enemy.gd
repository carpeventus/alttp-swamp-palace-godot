class_name Enemy extends CharacterBody2D

@export var damage: int = 1
@export var knockback_force: float = 160.0

@onready var health_compoent: HealthComponent = $HealthComponent as HealthComponent
@onready var hurt_box: HurtBox = $HurtBox


func _ready() -> void:
	health_compoent.died_signal.connect(_on_die)
	hurt_box.hurt_signal.connect(_on_hurt)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func _on_die() -> void:
	## todo dead effect
	queue_free()
	
func _on_hurt(damage_source: Damage) -> void:
	if damage_source.make_stun:
		pass
	elif health_compoent.current_health > 0:
		var attack_direction: Vector2 = (global_position - damage_source.source.global_position).normalized()
		if attack_direction == Vector2.ZERO:
			attack_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
		velocity = knockback_force * attack_direction
		var tween: Tween = create_tween()
		tween.tween_property(self, "velocity", Vector2.ZERO, 0.4)
