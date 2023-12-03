extends Area2D

@export var health_component: HealthComponent

signal hurt_signal

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	if not area is HitBox:
		return
	var hitbox := area as HitBox
	if health_component:
		health_component.take_damge(hitbox.damage)
	hurt_signal.emit()
	
