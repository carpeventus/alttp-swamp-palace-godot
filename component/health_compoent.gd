class_name HealthComponent extends Node

@export var max_health: int = 0

@onready var current_health: int = max_health

signal died_signal
signal health_changed_signal
signal health_decreased_signal
signal health_increased_signal


func heal(hp: int) -> void:
	take_damge(-hp)

func take_damge(damage: int) -> void:
	current_health = clamp(current_health - damage, 0 , max_health)
	died_signal.emit()
	if damage > 0:
		health_decreased_signal.emit()
	elif damage < 0:
		health_increased_signal.emit()
	if current_health <= 0:
		died_signal.emit()
