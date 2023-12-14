extends Enemy
@onready var health_compoent: HealthComponent = $HealthCompoent as HealthComponent


func _ready() -> void:
	health_compoent.died_signal.connect(_on_die)
	health_compoent.health_changed_signal.connect(_on_health_changed)
	
func _on_die() -> void:
	print("die")
	queue_free()

func _on_health_changed() -> void:
	print(health_compoent.current_health)
