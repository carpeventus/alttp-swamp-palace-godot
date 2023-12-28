extends Enemy

func _ready() -> void:
	super._ready()
	health_compoent.health_decreased_signal.connect(_on_health_decreased)
	
func _on_health_decreased() -> void:
	print("HP减少，还剩" + str(health_compoent.current_health))


