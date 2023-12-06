extends PlayerState


func on_enter() -> void:
	player.velocity = Vector2.ZERO
	player.forbidden_input = true
	player.anim_playback.travel("dying")

func on_exit() -> void:
	player.forbidden_input = false
