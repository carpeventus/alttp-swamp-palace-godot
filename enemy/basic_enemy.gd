extends Enemy
@onready var health_compoent: HealthComponent = $HealthCompoent as HealthComponent

func _ready() -> void:
	health_compoent.died_signal.connect(_on_die)

func _on_die() -> void:
	queue_free()
