class_name Interactable extends Area2D

signal interacted_signal

func _ready() -> void:
	body_entered.connect(_on_player_entered_area)
	body_exited.connect(_on_player_exited_area)


func _on_player_entered_area(body: Node2D) -> void:
	if body is Player:
		body.regist_interactable(self)

func _on_player_exited_area(body: Node2D) -> void:
	if body is Player:
		body.unregist_interactable(self)

func interact() -> void:
	interacted_signal.emit()
