extends Enemy
@onready var health_compoent: HealthComponent = $HealthCompoent as HealthComponent


func _ready() -> void:
	health_compoent.died_signal.connect(_on_die)
	health_compoent.health_decreased_signal.connect(_on_health_decreased)
	
func _on_die() -> void:
	queue_free()
	
func _on_health_decreased() -> void:
	print("HP减少，还剩" + str(health_compoent.current_health))
