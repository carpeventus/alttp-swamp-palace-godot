extends Enemy

@onready var direction_change_timer: Timer = $DirectionChangeTimer
@onready var enemy_death_effect_component: EnemyDeathEffectComponent = $EnemyDeathEffectComponent
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	direction_change_timer.timeout.connect(_on_timer_out)

func move() -> void:
	velocity_component.accelerate_in_direction(direction)

func destory_self() -> void:
	enemy_death_effect_component.generate_death_effect(global_position)
	queue_free()

func _on_timer_out() -> void:
	var direction_x: float = randf_range(-1.0, 1.0)
	var direction_y: float = randf_range(-1.0, 1.0)
	direction = Vector2(direction_x, direction_y).normalized()
