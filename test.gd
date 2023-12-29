extends Node2D

var hookshot_scene: PackedScene = preload("res://ability/hookshot.tscn")
@onready var player: Node2D = $Player


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook_right"):
		var hook: Hookshot = hookshot_scene.instantiate() as Hookshot
		add_child(hook)
		hook.generate_hookshot(player.global_position, Vector2.RIGHT, 192.0)
	elif event.is_action_pressed("hook_left"):
		var hook: Hookshot = hookshot_scene.instantiate() as Hookshot
		add_child(hook)
		hook.generate_hookshot(player.global_position, Vector2.LEFT, 192.0)
	elif event.is_action_pressed("hook_up"):
		var hook: Hookshot = hookshot_scene.instantiate() as Hookshot
		add_child(hook)
		hook.generate_hookshot(player.global_position, Vector2.UP, 192.0)
	elif event.is_action_pressed("hook_down"):
		var hook: Hookshot = hookshot_scene.instantiate() as Hookshot
		add_child(hook)
		hook.generate_hookshot(player.global_position, Vector2.DOWN, 192.0)
