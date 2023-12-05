extends Enemy
@onready var health_compoent: HealthComponent = $HealthCompoent as HealthComponent

func _ready() -> void:
	health_compoent.died_signal.connect(_on_die)
	health_compoent.health_decreased_signal.connect(_on_change)

func _on_die() -> void:
	print("enemy dead")

func _on_change() -> void:
	print(health_compoent.current_health)
