extends Node

@export var hurt_box: HurtBox
@export var sprite: Sprite2D
@export var hit_effect_shader: ShaderMaterial

func _ready() -> void:
	sprite.material = hit_effect_shader
	hurt_box.hurt_signal.connect(_on_hurted)


func _on_hurted(damage: Damage) -> void:
	var tween: Tween = create_tween()
	hit_effect_shader.set_shader_parameter("mix_ratio", 1.0)
	hit_effect_shader.set_shader_parameter("current_frame", 0)
	tween.tween_property(hit_effect_shader, "shader_parameter/current_frame", 7, 0.4).from(0)
	await tween.finished
	hit_effect_shader.set_shader_parameter("mix_ratio", 0.0)
	hit_effect_shader.set_shader_parameter("current_frame", 0)
