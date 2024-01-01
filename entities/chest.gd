class_name Chest extends StaticBody2D

@onready var interactable: Interactable = $Interactable
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false

func _ready() -> void:
	interactable.interacted_signal.connect(_on_interacted)

func _on_interacted() -> void:
	if is_open:
		return
	is_open = true
	animation_player.play("open")
