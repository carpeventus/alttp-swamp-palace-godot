class_name Sword extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var hit_box: HitBox = $HitBox
@onready var sprite: Sprite2D = $Sprite2D

@onready var sword_star_particle_down: GPUParticles2D = $SwordStarParticles/SwordStarParticleDown
@onready var sword_star_particle_up: GPUParticles2D = $SwordStarParticles/SwordStarParticleUp
@onready var sword_star_particle_right: GPUParticles2D = $SwordStarParticles/SwordStarParticleRight
@onready var sword_star_particle_left: GPUParticles2D = $SwordStarParticles/SwordStarParticleLeft

@onready var marker_right: Marker2D = $SwordEnergySpawnPosition/MarkerRight
@onready var marker_left: Marker2D = $SwordEnergySpawnPosition/MarkerLeft
@onready var marker_up: Marker2D = $SwordEnergySpawnPosition/MarkerUp
@onready var marker_down: Marker2D = $SwordEnergySpawnPosition/MarkerDown

@onready var sword_enegy_spawn_interval_timer: Timer = $SwordEnegySpawnIntervalTimer


var sword_energy_scene: PackedScene = preload("res://player/sword/sword_energy.tscn")


signal spin_attack_ready_signal

var is_hit_enmey: bool = false
var base_damage: int
var flash_tween: Tween

func _ready() -> void:
	animation_tree.active = true
	base_damage = hit_box.damage
	hit_box.body_entered.connect(_on_body_entered)
	hit_box.body_exited.connect(_on_body_exit)
	spin_attack_ready_signal.connect(_on_spin_attack_ready)

func _on_body_entered(body: Node2D) -> void:
	is_hit_enmey = true
	
func _on_body_exit(body: Node2D) -> void:
	is_hit_enmey = false


func attack(direction: Vector2) -> void:
	animation_tree["parameters/SwordAttack/blend_position"] = direction
	anim_playback.travel("SwordAttack")

func spin_attack(direction: Vector2) -> void:
	animation_tree["parameters/SwordSpinAttack/blend_position"] = direction
	anim_playback.travel("SwordSpinAttack")

func loading_idle(face_direction: Vector2) -> void:
	animation_tree["parameters/SwordLoadingIdle/blend_position"] = face_direction
	animation_tree["parameters/conditions/loading_cancel"] = false
	anim_playback.travel("SwordLoadingIdle")

func loading_walk(face_direction: Vector2) -> void:
	animation_tree["parameters/SwordLoadingWalk/blend_position"] = face_direction
	animation_tree["parameters/conditions/loading_cancel"] = false
	anim_playback.travel("SwordLoadingWalk")


func taping_enemy(face_direction: Vector2) -> void:
	animation_tree["parameters/SwordTapingEnemy/blend_position"] = face_direction
	anim_playback.travel("SwordTapingEnemy")

func cancel_loading() -> void:
	animation_tree["parameters/conditions/loading_cancel"] = true
	spin_attack_flash_shader_restore()
	stop_sword_star_particles()
	
func increase_hit_damage() -> void:
	hit_box.damage = base_damage * 2

func restore_hit_damage() -> void:
	hit_box.damage = base_damage

func _on_spin_attack_ready() -> void:
	sprite.material.set_shader_parameter("mix_ratio", 1.0)
	sprite.material.set_shader_parameter("current_frame", 0)
	if flash_tween:
		flash_tween.kill()
	flash_tween = create_tween()
	flash_tween.set_loops()
	flash_tween.tween_property(sprite.material, "shader_parameter/current_frame", 3, 0.4).from(0)

func spin_attack_flash_shader_restore() -> void:
	sprite.material.set_shader_parameter("mix_ratio", 0.0)
	sprite.material.set_shader_parameter("current_frame", 0)
	if flash_tween:
		flash_tween.kill()

func generate_sword_enegy(face_direction: Vector2) -> void:
	if not sword_enegy_spawn_interval_timer.is_stopped():
		return
	sword_enegy_spawn_interval_timer.start()
	var spawn_position: Vector2 = global_position
	if face_direction == Vector2.UP:
		spawn_position = marker_up.global_position
	elif face_direction == Vector2.DOWN:
		spawn_position = marker_down.global_position
	elif face_direction == Vector2.RIGHT:
		spawn_position = marker_right.global_position
	elif face_direction == Vector2.LEFT:
		spawn_position = marker_left.global_position
		
	var sword_energy: SwordEnergy = sword_energy_scene.instantiate() as SwordEnergy
	get_tree().get_first_node_in_group("EntitiesLayer").add_child(sword_energy)
	sword_energy.start_sowrd_energy_attack(face_direction, spawn_position)

func generate_sword_star_particles(direction: Vector2) -> void:
	if direction == Vector2.DOWN:
		sword_star_particle_down.emitting = true
	elif direction == Vector2.UP:
		sword_star_particle_up.emitting = true
	elif direction == Vector2.RIGHT:
		sword_star_particle_right.emitting = true
	elif direction == Vector2.LEFT:
		sword_star_particle_left.emitting = true
		
func stop_sword_star_particles() -> void:
	sword_star_particle_down.emitting = false
	sword_star_particle_up.emitting = false
	sword_star_particle_right.emitting = false
	sword_star_particle_left.emitting = false

func is_sword_star_particles_emtting() -> bool:
	return sword_star_particle_down.emitting \
	or sword_star_particle_up.emitting \
	or sword_star_particle_right.emitting \
	or sword_star_particle_left.emitting
