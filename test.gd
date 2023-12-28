extends Node2D

var hookshot_scene: PackedScene = preload("res://ability/hookshot.tscn")
@onready var player: Node2D = $Player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("item_use"):
		var hook: Hookshot = hookshot_scene.instantiate() as Hookshot
		add_child(hook)
		hook.hooked_signal.connect(_on_hooked)
		hook.generate_hookshot(player.global_position, Vector2.RIGHT, 192.0, 0.5, 0.3)


func _on_hooked(pos: Vector2) -> void:
	await get_tree().create_timer(0.2).timeout
	var tween: Tween = create_tween()
	tween.tween_property(player, "global_position", pos, 0.3)
