extends PlayerState


func on_enter() -> void:
	player.velocity = Vector2.ZERO
	player.anim_playback.travel("dying")
